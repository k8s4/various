# Simple mailer

$Delay = 60

$Body = "<h1>Добро пожаловать!</h1> <p><strong>Сформировано:</strong> $(Get-Date -Format g)</p>”
$Subject = "Отчет from some."
$path = "c:\mailer\attach1.jpg", "c:\mailer\attach2.txt"

$Username = "@gmail.com"
$Password = "************"
$Server = "smtp.gmail.com"
$Port = "587"

$From = $Username

foreach($Reciever in Get-Content "c:\mailer\list.txt") {
  $message = new-object System.Net.Mail.MailMessage

  $message.From = $From
  $message.To.Add($Reciever)
  $message.Subject = $Subject
  $message.Body = $Body
  $message.IsBodyHtml = $True

  foreach($Attach in $path) {
    $attachment = New-Object Net.Mail.Attachment($Attach)
    $message.Attachments.Add($attachment)
  }

  $smtp = New-Object System.Net.Mail.SmtpClient($Server, $Port)
  $smtp.EnableSSL = $True
  $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
  $smtp.send($message)

  write-host "Mail Sent to $Reciever"
  Start-Sleep -s $Delay
}
