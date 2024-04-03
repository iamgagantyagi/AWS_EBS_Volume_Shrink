# AWS_EBS_Volume_Shrink
This Repository Contains scripts and playbook that can be used to downsize the ebs volume attached to ec2 instance with zero time.

<!-- Introduction -->
## Introduction

This project is especially used for aws cost optimization. In AWS we attached ebs volume to ec2 instance based on storage requirement and most of the time they are are over-provisioned. So we have a way to reduce the cost by shrinking the (root and non rooted) volume with near zero downtime as there is no direct option to shrink the volume directly from aws console. So that's why I created a automated way using ansible playbook and script to manage this.


<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

You must have ansible installed in your local system.Below is the command to check the ansible.
  ```sh
  ansible --version
  ```

_Note: If the ansible is not installed then installed it !

### Installation

_Below is an example of how you can instruct your audience on installing and setting up ansible. This template doesn't rely on any external dependencies or services._

1. Clone the repo
   ```sh
   git clone https://github.com/iamgagantyagi/AWS_EBS_Volume_Shrink.git
   ```
2. Setup Ansible Vault for sudo password. 
   ```sh
   ansible-vault create credentails.yaml
   ```
   This will ask to create vault password and after that add the following enteries.
   
   ```sh
       ---
       ansible_ssh_pass: xxxx
       ansible_sudo_pass: xxxx
   ```
4. Create Another file to store the vault password.
   ```sh
   echo '123' > vault_password.txt
   ```
   _Note: To secure the vault manage the permission of vault_password file accordingly or use ansible vault encryption. 

5. Add the hosts.ini file and then run the script.
   ```sh
   bash aws_ebs_volume_shrink.sh [aws_use1_prod|aws_use1_qa|aws_usw2_qa|aws_usw2_prod] [volume-shrink]
   ```
   _Note: Select the region accordingly with the other parameter.


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<!-- CONTACT -->
## Contact

Your Name - [@Gagan_Tyagi](https://twitter.com/gtyagi017)

Project Link: [https://github.com/iamgagantyagi/AWS_EBS_Volume_Shrink](https://github.com/iamgagantyagi/AWS_EBS_Volume_Shrink)
