# MVM aka *Matrix vector multiplication*


# Main
a main function that asks the user to input n. Call functions read_matrix and
read_vector from main to read a matrix and a vector. Call function MVM to do matrix-vector
multiplication. Then call print_vector to print the result vector

# read_matrix
function read_matrix that allocates an array of n×n floats dynamically on
the heap, asks the user to input all n2 elements, stores the values in the matrix (starting at row 0,
then row 1, etc.), and returns a pointer (address) of the dynamically allocated matrix.

# read_vector
function read_vector that allocates an array of n floats dynamically on the
heap, asks the user to input all n elements, stores the values in the array, and returns a pointer
(address) of the dynamically allocated array.

# print_vector
function print_vector that prints the n float elements of the vector, whose
address is passed as an argument to the function.
# MVM translation from c++

```c++
float* MVM (int n, float A[n][n], float X[n]) {
float* V = new float[n]; // allocate an array of n floats
int i, j;
for (i=0; i<n; i++) {
float sum = 0;
for (j=0; j<n; j++) { sum = sum + A[i][j] * X[j]; }
V[i] = sum;
}
return V; // return a pointer to vector V
}
```
