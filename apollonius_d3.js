// require(['d3', 'dispatch', 'selection', 'drag'],
// function (d3, dis, sel, drag) {
    var svg = d3.select('#apollonius')
        .append('g')
        .attr('transform', 'translate(75 525) scale(50 -50)')

    // bind state to DOM
    // https://www.sitepoint.com/a-beginners-guide-to-data-binding-in-d3-js/
    // https://strongriley.github.io/d3/tutorial/circle.html

    // TODO: instead of fixing general position, automate change of coords
    var input = svg.append('g')
        .attr('class', 'input')

    input.selectAll('circle')
        .data([{x:0, y:0, r:1}, {x:2, y:0, r:1}, {x:2, y:2, r:1}])
        .enter() // for each new item
          .append('circle')

    // TODO: concisify
    // var inp = function(j) {return input.selectAll('circle').filter(function (d,i) {return i==j})}

    var output = svg.append('g')
        .attr('class', 'sols')

    // (-> fix the translation from state to graphic coords)
    svg.selectAll('circle')
       .attr('cx', function(d) {return d.x})
       .attr('cy', function(d) {return d.y})
       .attr('r', function(d) {return d.r})
       .style("fill-opacity", .2)
       .style("fill", "blue")
       .style("stroke-width", .05)
       .style("stroke", "red")

    // TODO: style data in CSS

	// event handlers
    // https://bl.ocks.org/mbostock/6123708

    function dragwrap(dragged) { // FIXME: do not snap to (0,0)!
        return d3.behavior.drag()
            .origin(function(d) { return d; })
            .on("dragstart", function(d) {
                  d3.event.sourceEvent.stopPropagation();
                  console.log('dragstarted: ' + d3.event.x + ", " + d3.event.y)
                })
            .on("drag", dragged)
            .on("dragend", function(d) {
                  // d3.select(this).classed("dragging", false)
                  submitState() // TODO: attempt realtime update
                })
    }
    var drag_xy = function(d) {
            d3.select(this)
              .attr("cx", d.x = d3.event.x)
              .attr("cy", d.y = d3.event.y)
            submitState() }
    var drag_x = function(d) {
            d3.select(this).attr("cx", d.x = d3.event.x)
            submitState() }

    /* var dispatch = d3.dispatch("scroll")
    dispatch.on("scroll", function(d) { d3.select(this)
                .attr("r", d.r = d.r + d3.event.wheelDeltaY) })
    dispatch.call("scroll", {d: d3.select(this).datum()}) */

    // bind event handlers
    // TODO: skip roundabout indexing

    input.selectAll('circle').filter(function (d,i) {return i==0})
       .call(dragwrap( function(d){} ))
    input.selectAll('circle').filter(function (d,i) {return i==1})
        .call(dragwrap( drag_x ))
    input.selectAll('circle').filter(function (d,i) {return i==2})
        .call(dragwrap( drag_xy ))

    // svg.call(zoom).on("wheel.zoom", scale)

	// api functions
    function submitState() {
        // http://stackoverflow.com/questions/11336251/accessing-d3-js-element-attributes-from-the-datum
        function d(i) {
            return input.selectAll('circle')[0][i].attributes
        }
        var py_in = "solve4circles("+
                  "polynomials("+
                    d(1).cx.value+',' + d(1).r.value+',' +
                    d(2).cx.value+',' + d(2).cy.value+',' + d(2).r.value +
                  "))"
        console.log(py_in)
        execute(py_in, updateData)
    }

    function updateData(py_out) {
		var ans = munge_reply(py_out, false)
        // console.log(ans)

        // TODO: flush old output, even when .exit().remove() is stale
        output.selectAll('circle')
                .remove()

        var c = output.selectAll('circle')
                 .data(ans)
        c.enter().append('circle')
           .attr('cx', function(d) {return d.x})
           .attr('cy', function(d) {return d.y})
           .attr('r', function(d) {return d.r})
           .style("fill-opacity", 0)
           .style("stroke-width", .05)
           .style("stroke", "red")
           .attr("pointer-events", "none") // still need access to our input!
    }
// });

// ipython callback utils forked from
// https://gist.github.com/tanyaschlusser/047148b1411ba4e05bb7

// python invoker
execute = function(python_code, callback){
    var kernel = IPython.notebook.kernel;
    if (!kernel) return;

    var msg_id = kernel.execute("",
        {shell: {reply: callback }}, // iopub: {output: custom_updater}
        {user_expressions:{output: python_code}} // silent:false
        );
    // TODO: link kernel.execute() docs
};

// python reply helper - collects python return value from the JSON
munge_reply = function(out, verbose=true){
    if (verbose) {
        console.log('munge_reply');
        console.log(out);
    }

    if ((out.content.user_expressions === undefined) ||
        (out.content.user_expressions.output === undefined)) {
      console.log("no content.user_expressions in python reply");
      return; // die on blank callback (kernel.execute -> shell/reply) from python
    }
    var output = out.content.user_expressions.output;
    if ((output.status != "ok") || (output.data === undefined)) {
      console.log("python didn't understand that call");
      return; // die on bad callback
    }

    // HACK: (i)python likes to give us JSON with single quotes, which are fatal
    // http://stackoverflow.com/questions/16450250/javascript-replace-single-quote-with-double-quote
    var res = output.data["text/plain"].replace(/'/g, '"');
    return JSON.parse(res);
};
