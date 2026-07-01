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
