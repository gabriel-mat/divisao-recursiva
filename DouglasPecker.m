function ResultList = DouglasPecker(PointList, limiar)
  if size(PointList, 1) < 3
    ResultList = PointList;
    return;
  end

  dmax = 0;
  index = 0;
  final = size(PointList, 1);

  for i = 2 : final - 1
    d = dist_reta(PointList(i, :), PointList(1, :), PointList(final, :));
    if(d > dmax)
      index = i;
      dmax = d;
    end
  end

  if(dmax > limiar)
    recResults1 = DouglasPecker(PointList(1 : index, :), limiar);
    recResults2 = DouglasPecker(PointList(index : final, :), limiar);
    ResultList = [recResults1(1:end-1, :); recResults2];
  else
    ResultList = [PointList(1, :); PointList(final, :)];
  end
end
