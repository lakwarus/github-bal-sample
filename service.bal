import ballerinax/github;
import ballerina/http;

      
type Repo record {
 string name;
 int star;
};        




# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + return - string name with hello message or error
    resource function get gitStarts() returns Repo[]|error {

        // Send a response back to the caller.
        github:Client githubEp = check new (config = {
            auth: {
                token: "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"
            }
        });

        stream<github:Repository, error?> getRepositoriesResponse = check githubEp->getRepositories();

        Repo[]|error? repos = from var item in getRepositoriesResponse 
            where item is github:Repository
            order by item.stargazerCount
            limit 5
            select {
                name: item.name,
                star: item.stargazerCount?: 0
            };
            return repos?:[];
    }
}
