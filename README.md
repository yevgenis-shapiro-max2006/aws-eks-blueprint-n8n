<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/2c336c4a-b668-4264-8883-b957de7723e9" />


## AWS | EKS SonarQube
SonarQube is a code quality and application security platform. It analyzes your source code and finds problems before the code reaches production.



🎯 Architecture Overview
```
🔐 Security vulnerabilities — insecure code that attackers could exploit
🐛 Bugs — code likely to cause runtime problems
🧹 Code smells — code that is difficult to maintain or unnecessarily complex
📋 Duplicated code
🧪 Test coverage — how much code is covered by tests
📐 Code quality — maintainability and reliability
🔎 Security Hotspots — code that requires security review
```


🧱 Features
```
✔ Fully automated provisioning with Terraform
✔ High availability using multiple subnets in different Availability Zones
✔ Secure connectivity between Application and RDS
✔ Configurable environment variables for database credentials
✔ Easy to extend for other JSON data source
```



🚀 Deployment Options
```
terraform init
terraform validate
terraform plan -var-file="template.tfvars"
terraform apply -var-file="template.tfvars" -auto-approve
```

