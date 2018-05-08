self: super: hoverlays: hself: hsuper:
  let extend = lhs: rhs: lhs // rhs lhs;
  in  super.lib.foldl extend hsuper (map (hol: hol hself) hoverlays)
