function ResultList = DouglasPeucker(PointList, limiar)
%{
A função `Douglas Peucker` simplifica uma curva poligonal reduzindo a quantidade 
de pontos da mesma, utilizando a estratégia de recursão. O algoritmo preserva
as formas com base em uma tolerância geométrica.

Entrada:
  - PointList : Matriz contendo as coordenadas cartesianas [X, Y] de todos
                os pontos originais do contorno da curva.
  - limiar    : Valor numérico que define a distância máxima tolerada (em pixels) 
                entre a curva original e a reta simplificada.
                Limiares maiores geram curvas mais simplificadas (com menos pontos).

Saída:
  - ResultList: Matriz que contém as coordenadas [X, Y] dos ponto que foram mantidos 
                após a simplificação.
%}  
  
  
%{
Se a lista recebida tiver menos de 3 pontos (ou seja, apenas 1 ou 2 pontos), 
não há o que simplificar. Uma reta já é a forma mais simples possível.
%}  
  if size(PointList, 1) < 3
    ResultList = PointList;
    return;
  end

  dmax = 0;
  index = 0;
  final = size(PointList, 1);
  
%{
Achar o ponto intermediário com maior distância perpendicular em relação à 
reta formada pelo ponto inicial e final do segmento atual.
%}    
  for i = 2 : final - 1
    d = dist_reta(PointList(i, :), PointList(1, :), PointList(final, :));
    if(d > dmax)
      index = i;
      dmax = d;
    end
  end
%{
Se o dmax for maior que o limiar, ele não pode ser ignorado. O processo recursivo
será aplicado dividindo o segmento em duas novas subcurvas a partir deste ponto 
de maior distância.

Caso contrário, ignora-se todos os pontos intermediários, mantendo apenas o ponto 
inicial e final do segmento atual.
%}
  if(dmax > limiar)
    recResults1 = DouglasPeucker(PointList(1 : index, :), limiar);
    recResults2 = DouglasPeucker(PointList(index : final, :), limiar);
    ResultList = [recResults1(1:end-1, :); recResults2];
  else
    ResultList = [PointList(1, :); PointList(final, :)];
  end
end