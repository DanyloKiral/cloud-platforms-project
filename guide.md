# How to install and use project
1. Install .NET Core latest (3.1), Terraform, Azure CLI tools, Visual Studio to your computer.
2. Run 'az login' command and login to your Azure account.
3. Clone repository with source code from [here](https://github.com/DanyloKiral/cloud-platforms-project).
4. Open cmd or terminal in the root of the repository.
5. Run ‘terraform init’ command.
6. Run ‘terraform apply’ command to create Azure cloud infrastructure. Type ‘yes’ when requested.
7. Navigate to CloudPlatrforms.Project.Functions folder and run ‘func azure functionapp publish statistics-analizer-funcs’ command to deploy Azure functions.
8. Open cloud-platforms-project.sln file with Visual Studio. Right click on the CloudPlatrforms.Project.WebApi project and select Publish -> Publish to Azure.
Then select your account and statistics-aggregator-app-service App service.
Click the Publish button.

FILE 1

9. Now everything is deployed and you can load a JSON file with the Reddit comments archive to projectdatastore into the reddit-comments-archive container. (Archives you can take from here. Do not forget to unarchive files).

FILE 2

10. Functions will be triggered and after some time you can make a GET request to App service (https://statistics-aggregator-app-service.azurewebsites.net/statistics) for statistics.

FILE 3

# Some screenshots from Azure with working solution

Storage resource group:

Computing resource group:

Azure functions metrics:

App service metrics:

Event hub metrics:

