#include <stdio.h>
//Read from the console a list of numbers in base 10. Write to the console only the prime numbers.
//functia din 21_prime.asm
int Prime(int x);


int main()
{
    int n, a[100];
    printf("n= ");
    scanf("%d", &n);


    printf("The list of numbers is: ");
    for (int i = 1; i <= n; ++i)
        scanf("%d", &a[i]);

    printf("The list of prime numbers is: ");
    for (int i = 1; i <= n; ++i)
        if (Prime(a[i]) != -1)//apelam functia
            printf("%d ", a[i]);

    return 0;
}