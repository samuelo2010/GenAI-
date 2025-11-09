##practice functions without parameters
def greet(){
    return "Hello, welcome to the practice function!";
    }

## function with parameters
def add_numbers(a:int, b:int){
    print(f"The sum of a and b is: {a + b}");

    }

##function that return a value
def multiply_numbers(a:int, b:int)->int{
    return a * b;}
with entry{
    msg=greet();
    print(msg);
    add_numbers(5, 10);
    result=multiply_numbers(4, 6);
    print(f"The multiplication result is: {result}");            
    }