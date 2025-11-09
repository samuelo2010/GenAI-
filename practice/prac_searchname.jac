#person node
node person{
    has name:str;   
}
#searchname walker
walker searchname{
    has target:str;
    has found:bool = False;
    can start with `root entry{
        print("Starting the search for names starting with 'A'");
        visit[-->]; }
    can find_name with person entry {
        if here.name == self.target{
            print(f"Found a person with name starting with: {here.name}");
            self.found = True;
            disengage;}
        visit[-->]; }}
#entry point of the walker
with entry{
    #create some person nodes
    sam=person(name="Sam");
    alex=person(name="Alex");
    bob=person(name="Bob");
    anna=person(name="Anna");
    #create links between the nodes
    root++>alex++>bob++>sam++>anna;
    #start the walker to search for names starting with 'A'
    searcher=searchname(target="Bob");
    root spawn searcher;
    print(f"person found  {searcher.found}");}
    
