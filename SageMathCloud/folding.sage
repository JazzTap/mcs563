# reusable higher-order operations
def numeric_matrix(A):
    return matrix( [[j.n() for j in row]
                    for row in A] )
def numeric_dict(x):
    return dict( (k,v.n()) for (k,v) in x.items() )

    # TODO: infer from type (efficiently)

def op_dict_add(dic, vec):
    # TODO: take any binary operator as (function) argument
    return dict(zip(dic.keys(), vector(dic.values()) + vec))