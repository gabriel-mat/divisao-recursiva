close all; clear; clc;

% Carregar imagens.
img = imread("banco/brasil.jpg");

% Se a imagem for RGB, transformar ela em imagem em níveis de cinza.
if size(img, 3) == 3 
    img_gray = rgb2gray(img); 
else
    img_gray = img;
end

img_binaria = img_gray < 128; % binarizacao

%{
A função bwboundaries traça os contornos do objeto em uma imagem binária.
- Usa conectividade 8 (todos os vertíces do pixel central).
- Não considera contorno internos.
%}  
bordas = bwboundaries(img_binaria, 8, 'noholes'); 

%{
Loop para encontrar o objeto com maior quantidade de pixels na borda.
%}
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
Utiliza o algoritmo Douglas Peucker para simplificar a borda do objeto com base
no limiar.
%} 
result0 = DouglasPeucker(PointList, 0);
result1 = DouglasPeucker(PointList, 10);
result2 = DouglasPeucker(PointList, 50);
% O limiar 50 preserva apenas os vertices mais significativos, gerando um poligono bem mais simples

% Apresentação dos resultados
figure;

subplot(2, 2, 1);
imshow(img);
title('Imagem Original');

subplot(2, 2, 2);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result0(:, 1), result0(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 3);
legend('Contorno Solido', 'Limiar 0');
title('Divisao Recursiva (Limiar = 0)');
hold off;

subplot(2, 2, 3);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result1(:, 1), result1(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 10);
legend('Contorno Solido', 'Limiar 10');
title('Divisao Recursiva (Limiar = 10)');
hold off;

subplot(2, 2, 4);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result2(:, 1), result2(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 10);
legend('Contorno Solido', 'Limiar 50');
title('Divisao Recursiva (Limiar = 50)');
hold off;


figure;

subplot(1,3,1);
numVertices = size(result0,1);
plot(result0(:, 1), result0(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 3);
axis equal;
set(gca,'YDir','reverse');
grid on;
title(sprintf('Limiar = 0\n%d vertices', numVertices));

subplot(1,3,2);
numVertices = size(result1,1);
plot(result1(:, 1), result1(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 10);
axis equal;
set(gca,'YDir','reverse');
grid on;
title(sprintf('Limiar = 10\n%d vertices', numVertices));

subplot(1,3,3);
numVertices = size(result2,1);
plot(result2(:, 1), result2(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 10);
axis equal;
set(gca,'YDir','reverse');
grid on;
title(sprintf('Limiar = 50\n%d vertices', numVertices));
