%{
  PP2 - Processamento de imagens

  André Alves Paula da Costa - 834681
  Gabriel Matheus de Souza - 832254
  Letícia Ramos Fernandes - 834748
  Otávio Inácio de Oliveira - 831718

%}

close all; clear; clc;

% Carrega imagens.
img = imread("banco/rio_amazonas.jpg");

% Se a imagem for RGB, transforma em níveis de cinza.
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

% Opções de pré-processamento

%img_filtro = img_gray;
%img_filtro = medfilt2(img_gray); % Filtro Mediana
img_filtro = imgaussfilt(img_gray, 1); % Suavização Gaussiana
%img_filtro = imcomplement(img_binaria); % Inverte


% Binarização

img_binaria = imbinarize(img_filtro);
%img_binaria = img_gray < 128;

figure
subplot(2,2,1), imshow(img), title('Imagem original');
subplot(2,2,2), imshow(img_gray), title ('Imagem em tons de cinza');
subplot(2,2,3), imshow(img_filtro), title ('Imagem com filtro');
subplot(2,2,4), imshow(img_binaria), title ('Imagem binarizada');


%{
A função bwboundaries traça os contornos do objeto em uma imagem binária.
- Usa conectividade 8 (todos os vertíces do pixel central).
- Não considera contorno internos.
%}
bordas = bwboundaries(img_binaria, 8, 'noholes');

%Loop para encontrar o objeto com maior quantidade de pixels na borda.
maior_idx = 1;
maior_tamanho = 0;
for k = 1:length(bordas)
    if size(bordas{k}, 1) > maior_tamanho
        maior_tamanho = size(bordas{k}, 1);
        maior_idx = k;
    end
end

%{
PointList é uma matriz no formato [X,Y] de todos os pontos do objeto com maior
quantidade de pixels na borda.
%}
PointList = [bordas{maior_idx}(:, 2), bordas{maior_idx}(:, 1)];

%{
Utiliza o algoritmo Douglas Peucker para simplificar a borda do
objeto com baseno limiar.
Um limiar maior preserva apenas os vertices mais significativos,
gerando um poligono bem mais simples.
%}
limiar0 = 0;
limiar1 = 5;
limiar2 = 15;
limiar3 = 30;

result0 = DouglasPeucker(PointList, limiar0);
result1 = DouglasPeucker(PointList, limiar1);
result2 = DouglasPeucker(PointList, limiar2);
result3 = DouglasPeucker(PointList, limiar3);

% Apresentação dos resultados nas imagens
figure;

subplot(2, 2, 1);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result0(:, 1), result0(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 2);
legend('Contorno Sólido', sprintf('Limiar %d', limiar0));
title(sprintf('Divisão Recursiva (Limiar = %d)', limiar0));
hold off;

subplot(2, 2, 2);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result1(:, 1), result1(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 4);
legend('Contorno Sólido', sprintf('Limiar %d', limiar1));
title(sprintf('Divisão Recursiva (Limiar = %d)', limiar1));
hold off;

subplot(2, 2, 3);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result2(:, 1), result2(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 4);
legend('Contorno Sólido', sprintf('Limiar %d', limiar2));
title(sprintf('Divisão Recursiva (Limiar = %d)', limiar2));
hold off;

subplot(2, 2, 4);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result3(:, 1), result3(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 4);
legend('Contorno Sólido', sprintf('Limiar %d', limiar3));
title(sprintf('Divisão Recursiva (Limiar = %d)', limiar3));
hold off;

% Apresentação dos polígonos no grid
figure;

subplot(2,2,1);
numVertices = size(result0,1);
plot(result0(:, 1), result0(:, 2), 'r-o', 'LineWidth', 2, 'MarkerSize', 1);
axis equal;
set(gca,'YDir','reverse');
grid on;
title(sprintf('Limiar = %d (%d vértices)', limiar0, numVertices));

subplot(2,2,2);
numVertices = size(result1,1);
plot(result1(:, 1), result1(:, 2), 'r-o', 'LineWidth', 1, 'MarkerSize', 3);
axis equal;
set(gca,'YDir','reverse');
grid on;
title(sprintf('Limiar = %d (%d vértices)', limiar1, numVertices));

subplot(2,2,3);
numVertices = size(result2,1);
plot(result2(:, 1), result2(:, 2), 'r-o', 'LineWidth', 1, 'MarkerSize', 3);
axis equal;
set(gca,'YDir','reverse');
grid on;
title(sprintf('Limiar = %d (%d vértices)', limiar2, numVertices));

subplot(2,2,4);
numVertices = size(result3,1);
plot(result3(:, 1), result3(:, 2), 'r-o', 'LineWidth', 1, 'MarkerSize', 3);
axis equal;
set(gca,'YDir','reverse');
grid on;
title(sprintf('Limiar = %d (%d vértices)', limiar3, numVertices));

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

