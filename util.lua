function collide(a1, a2)
  return a1.x < a2.x+a2.colX and
         a2.x < a1.x+a1.colX and
         a1.y < a2.y+a2.colY and
         a2.y < a1.y+a1.colY
end