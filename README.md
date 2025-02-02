PowerShell RansoDetect 1.0
==========================

This directory contains an experimental PowerShell script that aims to detect the presence of a running ransomware on a computer. The script creates a fake document file in user's home directory and regularly monitors any changes on it. If the file is renamed or edited, the script executes several actions such as sending an email to the cybersecurity team, prompting the user to take actions, and emetting an alert sound.  

Script written for learning purposes only. Use with precaution.


Screenshot
----------

![screenshot](https://github.com/user-attachments/assets/5b1ba252-392d-49e3-9f1c-4f78cf931b52)

The screenshot above shows a PowerShell window created when a ransomware has potentially been detected.


License
-------

This work is shared under the [MIT license](LICENSE).
