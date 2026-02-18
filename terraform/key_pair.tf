# WHY: Upload the public key to AWS so we can SSH into servers
resource "aws_key_pair" "deployer" {
  key_name   = "junior-devops-key"
  
  # WHY: Instead of pasting the long key, we read it from the file.
  public_key = file("~/.ssh/id_ed25519.pub")
}