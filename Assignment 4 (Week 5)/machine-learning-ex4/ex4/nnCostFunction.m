function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

X = [ones(m,1) X];

bigdelta1 = zeros(size(Theta1));
bigdelta2 = zeros(size(Theta2));

for i=1:m
	hidden = sigmoid(X(i,:) * Theta1'); % 1 x 25 representing hiden layer activation cost (after applying to sigmoid)
	z_2 = (X(i,:) * Theta1')';
	z_2 = [1; z_2];
	hidden = [ones(size(hidden,1),1) hidden];
	output = sigmoid(hidden * Theta2'); % 1 x 10 representing probability of last layer (output layer)
	y_vector = zeros(num_labels,1);
	y_vector(y(i)) = 1;
	for k=1:num_labels
		J = J + (-y_vector(k) * log(output(k))) - ((1-y_vector(k)) * log(1-output(k)));
	end

	delta = output' - y_vector;
	delta_2 = (Theta2' * delta) .* sigmoidGradient(z_2);
	delta_2 = delta_2(2:end);

	bigdelta2 = bigdelta2 + (delta * hidden);
	bigdelta1 = bigdelta1 + (delta_2 * X(i,:));

end

bigdelta1 = (1/m) .* bigdelta1;
bigdelta2 = (1/m) .* bigdelta2;

bigdelta1 = bigdelta1 + ((lambda / m) .* Theta1);
bigdelta2 = bigdelta2 + ((lambda / m) .* Theta2);

bigdelta1(:,1) = bigdelta1(:,1) - ((lambda / m) .* Theta1(:,1));
bigdelta2(:,1) = bigdelta2(:,1) - ((lambda / m) .* Theta2(:,1));


J = J / m ;

Theta1_reg = Theta1(:, 2:end);
Theta1_reg = Theta1_reg .^ 2;

Theta2_reg = Theta2(:, 2:end);
Theta2_reg = Theta2_reg .^ 2;

J = J + ((lambda / (2 * m)) * (sum(sum(Theta1_reg)) + sum(sum(Theta2_reg))));















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [bigdelta1(:); bigdelta2(:)];


end
