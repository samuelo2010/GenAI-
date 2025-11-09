##Calculator
obj calc{
    has x:int=0;
    has y:int=0;
    has result:float=0.0;
   

    def calc_entry(a:int,b:int){
        this.x = a;
        this.y = b;
    }
    def add()->float{
        this.result = this.x + this.y;
        return this.result;
    }   
    def subtract()->float{
        this.result = this.x - this.y;
        return this.result;
    }
    def multiply(){
        this.result = this.x * this.y;
        return this.result;
    }
    def divide(){
        if(this.y != 0){
            this.result = this.x / this.y;
            return this.result;
        } else {
            this.result = 0;
            return this.result; ## Handle division by zero
        }
    }   
    with entry:__main__ {
        c = calc();
        c.calc_entry(10, 5);
        c.add();
        print("Addition Result: c.result");
        c.subtract();
        print(f"Subtraction Result: c.result");
        c.multiply();
        print(f"Multiplication Result: c.result");
        c.divide();
        print(f"Division Result: c.result");
    }


}