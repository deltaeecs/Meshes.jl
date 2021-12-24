# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    intersecttype(f, l1, l2)

Compute the intersection type of two lines `l1` and `l2`
and apply function `f` to it.

The intersection type can be one of three types:

1. intersect at one point
2. overlap at more than one point
3. do not overlap nor intersect
"""
function intersecttype(f::Function, l1::Line{3,T}, l2::Line{3,T}) where {T}
  a, b = l1(0), l1(1)
  c, d = l2(0), l2(1)

  if measure(Tetrahedron(a, b, c, d)) > 0
    return NoIntersection() |> f
  elseif isapprox(abs((b - a) × (c - d)), zero(T), atol=atol(T)^2)
    return OverlappingLines(l1) |> f
  else
    return CrossingLines(intersectpoint(l1, l2)) |> f
  end
end

function intersecttype(f::Function, l1::Line{2,T}, l2::Line{2,T}) where {T}
  a, b = l1(0), l1(1)
  c, d = l2(0), l2(1)

  if !isapprox(abs((b - a) × (c - d)), zero(T), atol=atol(T)^2)
    return CrossingLines(intersectpoint(l1, l2)) |> f
  elseif isapprox(measure(Triangle(a, b, c)), zero(T), atol=atol(T)^2)
    return OverlappingLines(l1) |> f
  else
    return NoIntersection() |> f
  end
end

# compute the intersection of two lines assuming that it is a point
function intersectpoint(l1::Line{2}, l2::Line{2})
  a, b = l1(0), l1(1)
  c, d = l2(0), l2(1)

  v1  = a - b
  v2  = c - d
  v12 = a - c

  # the intersection point lies in between a and b at a fraction s
  # (https://en.wikipedia.org/wiki/Line-line_intersection#Formulas)
  s = (v12[1] * v2[2] - v12[2] * v2[1]) / (v1[1] * v2[2] - v1[2] * v2[1])

  a - s*v1
end
