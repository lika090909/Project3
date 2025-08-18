

resource "null_resource" "bastion-connection" {
  depends_on = [ module.ec2-instance_bastion-az1 ]
  connection {
    type = "ssh"
    host = module.ec2-instance_bastion-az1.public_ip
    user = "ec2-user"
    private_key = file("/Users/angelika/Downloads/devops.pem")
      
  }
  
    # optional wait before doing anything
  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting 25s for EC2 to settle...'",
      "sleep 25"
    ]
  }

   # Passing the private ec2 instance key to the bastioncount 

  provisioner "file" {
    
    source = "/Users/angelika/Downloads/private-ec2-key.pem"
    destination = "/tmp/private-ec2-key.pem"
    
  }

  # changing the permission of the ec2 private key from bastion /tmp
  
  provisioner "remote-exec" {
    
    inline = [

        "sudo chmod 400 /tmp/private-ec2-key.pem"
    ]
       
  }
}