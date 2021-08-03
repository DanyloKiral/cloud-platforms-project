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

![image](https://user-images.githubusercontent.com/15198798/128075490-657aa249-848d-49aa-be88-91c6fae8e22d.png)

9. Now everything is deployed and you can load a JSON file with the Reddit comments archive to projectdatastore into the reddit-comments-archive container. (Archives you can take from here. Do not forget to unarchive files).

![image](https://user-images.githubusercontent.com/15198798/128075544-69823d70-99bd-4c9d-93a7-abc47ee181c5.png)

10. Functions will be triggered and after some time you can make a GET request to App service (https://statistics-aggregator-app-service.azurewebsites.net/statistics) for statistics.

![image](https://user-images.githubusercontent.com/15198798/128075131-2557882d-5227-4638-ab67-edddd9b42a82.png)

# Some screenshots from Azure with working solution

Storage resource group:

![image](https://user-images.githubusercontent.com/15198798/128075954-b1f172a8-7590-4636-956d-1fa02788dd18.png)

Computing resource group:

![image](https://user-images.githubusercontent.com/15198798/128075915-428bfc09-1511-454b-b92f-e1cdce110d4a.png)

Azure functions metrics:

![image](https://user-images.githubusercontent.com/15198798/128075250-a76b3a09-1533-41b2-b7da-3afa60259bb8.png)

App service metrics:

![image](https://user-images.githubusercontent.com/15198798/128075709-670efbda-9fa3-47ed-b982-1a6791026863.png)

Event hub metrics:

![image](https://user-images.githubusercontent.com/15198798/128075328-130a6f83-56a9-45b9-8d0e-babecd9223fa.png)
