#=
This is a Julia translation of Expokit's PADM Matlab implementation. This 
algorithm computes the matrix exponential exp(A) of a large sparse matrix 
using Pade approximants. See original description below, and its license.

AUTHOR: Marcelo Forets (2017-07-10) : initial implementation

*******************************************************************************
%  E = padm( A, p )
%  PADM computes the matrix exponential exp(A) using the irreducible 
%  (p,p)-degree rational Pade approximation to the exponential function.
%
%  E = padm( A )
%  p is internally set to 6 (recommended and generally satisfactory).
%
%  See also CHBV, EXPOKIT and the MATLAB supplied functions EXPM and EXPM1.

%  Roger B. Sidje (rbs@maths.uq.edu.au)
%  EXPOKIT: Software Package for Computing Matrix Exponentials.
%  ACM - Transactions On Mathematical Software, 24(1):130-156, 1998
*******************************************************************************
=#
function padm(A::SparseMatrixCSC{Float64, Int64}, p::Int64=6)

n = size(A, 1)

# Pade coefficients (1-based instead of 0-based as in the literature)

c = Float64[]
push!(c, 1.0)
@inbounds for k = 1:p
    push!(c, c[end] * ((p+1-k)/(k*(2*p+1-k))))
end

# Scaling

normA = norm(A, Inf)
s = 0
if normA > 0.5
    s = max(0, round(Int64, log(normA)/log(2), RoundToZero) + 2)
    A = 2.0^(-s) * A
end

# Horner evaluation of the irreducible fraction (see ref. above)

I = speye(n)
A2 = A * A
Q = c[p+1] * I
P = c[p] * I
odd = 1
@inbounds for k = p-1:-1:1
    if odd == 1
        Q = Q * A2 + c[k] * I
    else
        P = P * A2 + c[k] * I
    end
    odd = 1 - odd;
end
if odd == 1
    Q = Q * A
    Q = Q - P

    # MethodError: no method matching A_ldiv_B!(::Base.SparseArrays.UMFPACK.UmfpackLU{Float64,Int64}, ::SparseMatrixCSC{Float64,Int64})
    #E = -(I + 2 * (Q\P))
    #E = -(I + 2 * inv(P) * Q)
    E = -(I + 2 * sparse((full(Q)\full(P))))
else
    P = P * A;
    Q = Q - P;
    #E = I + 2 * inv(P) * Q
    E = I + 2 * sparse(full(Q)\full(P))
end

# Squaring

@inbounds for k = 1:s
    E = E * E
end

return E

end
