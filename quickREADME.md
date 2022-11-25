# Mips-quicksort


## main
Checks the condition n>1.
Calls all the function and saves the array address , n and return address
## print_array
itarate over the dynamic array and prints every value

## read_array
gets from the user the desired array length as well as the values saved inside


## quick_sort:
### The code uses dynamic heap to translate this quicksort from c++ into mips:
```c++
void quick_sort(int array[], int low, int high) {
int i = low, j = high; // low and high index
int pivot = array[(low+high)/2]; // pivot = middle value
while (i <= j) {
while (array[i] < pivot) i++;
while (array[j] > pivot) j--;
if (i <= j) {
int temp=array[i];
array[i]=array[j]; // swap array[i]
array[j]=temp; // with array[j]
i++;
j--;
}
}
if (low < j) quick_sort(array, low, j); // Recursive call 1
if (i < high) quick_sort(array, i, high); // Recursive call 2
}
```
