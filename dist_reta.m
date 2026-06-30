function d = dist_reta(ponto, p1_reta, p2_reta)
%{
A função `dist_reta` calcula a menor distância (perpendicular) entre um ponto 
geométrico e uma reta definida por dois outros pontos. Caso os pontos da reta 
sejam idênticos, calcula a distância Euclidiana entre os dois pontos.

Entrada:
  - ponto   : Vetor com as coordenadas [X, Y] do ponto.
  - p1_reta : Vetor com as coordenadas [X, Y] do ponto inicial da reta.
  - p2_reta : Vetor com as coordenadas [X, Y] do ponto final da reta.

Saída:
  - d       : Valor numérico (escalar) que representa a distância calculada
              (em pixels) entre o ponto e a reta.
%}   
    x0 =   ponto(1); y0 = ponto(2);
    x1 = p1_reta(1); y1 = p1_reta(2);
    x2 = p2_reta(1); y2 = p2_reta(2);

    if (x1 == x2 && y1 == y2)
        d = sqrt((x0 - x1)^2 + (y0 - y1)^2);
    else
        num = abs((y2 - y1)*x0 - (x2 - x1)*y0 + x2*y1 - y2*x1);
        den = sqrt((y2 - y1)^2 + (x2 - x1)^2);
        d = num / den;
    end
end
