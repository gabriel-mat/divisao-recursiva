close all; clear; clc;

% Carregar imagens.
img = imread("banco/brasil.jpg");

% Se a imagem for RGB, transformar em níveis de cinza.
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

img_binaria = img_gray < 128; % Binarização

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
limiar1 = 10;
limiar2 = 50;

result0 = DouglasPeucker(PointList, limiar0);
result1 = DouglasPeucker(PointList, limiar1);
result2 = DouglasPeucker(PointList, limiar2);

% Apresentação dos resultados nas imagens
figure;

subplot(2, 2, 1);
imshow(img);
title('Imagem Original');

subplot(2, 2, 2);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result0(:, 1), result0(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 2);
legend('Contorno Sólido', sprintf('Limiar %d', limiar0));
title(sprintf('Divisão Recursiva (Limiar = %d)', limiar0));
hold off;

subplot(2, 2, 3);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result1(:, 1), result1(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 4);
legend('Contorno Sólido', sprintf('Limiar %d', limiar1));
title(sprintf('Divisão Recursiva (Limiar = %d)', limiar1));
hold off;

subplot(2, 2, 4);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result2(:, 1), result2(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 4);
legend('Contorno Sólido', sprintf('Limiar %d', limiar2));
title(sprintf('Divisão Recursiva (Limiar = %d)', limiar2));
hold off;

% Apresentação dos polígonos no grid
figure;

subplot(1,3,1);
numVertices = size(result0,1);
plot(result0(:, 1), result0(:, 2), 'r-o', 'LineWidth', 1, 'MarkerSize', 2);
axis equal;
set(gca,'YDir','reverse');
title(sprintf('Limiar = %d (%d vértices)', limiar0, numVertices));

subplot(1,3,2);
numVertices = size(result1,1);
plot(result1(:, 1), result1(:, 2), 'r-o', 'LineWidth', 1, 'MarkerSize', 4);
axis equal;
set(gca,'YDir','reverse');
title(sprintf('Limiar = %d (%d vértices)', limiar1, numVertices));

subplot(1,3,3);
numVertices = size(result2,1);
plot(result2(:, 1), result2(:, 2), 'r-o', 'LineWidth', 1, 'MarkerSize', 4);
axis equal;
set(gca,'YDir','reverse');
title(sprintf('Limiar = %d (%d vértices)', limiar2, numVertices));
