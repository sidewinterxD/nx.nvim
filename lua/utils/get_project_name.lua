return function(dec, pjpath)
  if dec and dec.name and type(dec.name) == "string" then
    return dec.name
  end
  return fn.fnamemodify(pjpath, ":h:t")
end
