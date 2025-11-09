#define node person with name
node person {
    has name : str ;
    }

#define walker to say hellow to the person
walker say_hello {
    can start with `root entry{
        print("Hello, the walker is starting the journey");
        visit[-->]; }
    can greet with person entry {
        print(f"Hello, {here.name}! How are you today?");
        visit[-->]; }}
#entry point of the walker
with entry{
    #create some person nodes
    sam=person(name="Sam");
    alex=person(name="Alex");
    bob=person(name="Bob");
    #create links between the nodes
    root++>alex++>bob++>sam;
    #start the walker
    root spawn say_hello();
}