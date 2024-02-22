control 'V-73253' do
  title "Permissions for the Windows installation directory must conform to
  minimum requirements."
  desc "Changing the system's file and directory permissions allows the
  possibility of unauthorized and anonymous modification to the operating system
  and installed applications.

  The default permissions are adequate when the Security Option Network
  access: Let everyone permissions apply to anonymous users is set to
  Disabled (WN16-SO-000290).
  "
  impact 0.5
  tag "gtitle": 'SRG-OS-000312-GPOS-00122'
  tag "satisfies": ['SRG-OS-000312-GPOS-00122', 'SRG-OS-000312-GPOS-00123',
                    'SRG-OS-000312-GPOS-00124']
  tag "gid": 'V-73253'
  tag "rid": 'SV-87905r1_rule'
  tag "stig_id": 'WN16-00-000180'
  tag "fix_id": 'F-79697r1_fix'
  tag "cci": ['CCI-002165']
  tag "nist": ['AC-3 (4)', 'Rev_4']
  tag "documentable": false
  desc "check", "The default permissions are adequate when the Security Option
  Network access: Let everyone permissions apply to anonymous users is set to
  Disabled (WN16-SO-000290).

  Review the permissions for the Windows installation directory (usually
  C:\\Windows). Non-privileged groups such as Users or Authenticated Users must
  not have greater than Read & execute permissions. (Individual accounts must
  not be used to assign permissions.)

  If permissions are not as restrictive as the default permissions listed below,
  this is a finding.

  Viewing in File Explorer:

  For each folder, view the Properties.

  Select the Security tab and the Advanced button.

  Default permissions:
  Windows
  Type - Allow for all
  Inherited from - None for all

  Principal - Access - Applies to

  TrustedInstaller - Full control - This folder and subfolders
  SYSTEM - Modify - This folder only
  SYSTEM - Full control - Subfolders and files only
  Administrators - Modify - This folder only
  Administrators - Full control - Subfolders and files only
  Users - Read & execute - This folder, subfolders, and files
  CREATOR OWNER - Full control - Subfolders and files only
  ALL APPLICATION PACKAGES - Read & execute - This folder, subfolders, and files
  ALL RESTRICTED APPLICATION PACKAGES - Read & execute - This folder, subfolders,
  and files

  Alternately, use icacls:

  Open a Command prompt (admin).

  Enter icacls followed by the directory:

  icacls c:\\windows

  The following results should be displayed for each when entered:

  c:\\windows
  NT SERVICE\\TrustedInstaller:(F)
  NT SERVICE\\TrustedInstaller:(CI)(IO)(F)
  NT AUTHORITY\\SYSTEM:(M)
  NT AUTHORITY\\SYSTEM:(OI)(CI)(IO)(F)
  BUILTIN\\Administrators:(M)
  BUILTIN\\Administrators:(OI)(CI)(IO)(F)
  BUILTIN\\Users:(RX)
  BUILTIN\\Users:(OI)(CI)(IO)(GR,GE)
  CREATOR OWNER:(OI)(CI)(IO)(F)
  APPLICATION PACKAGE AUTHORITY\\ALL APPLICATION PACKAGES:(RX)
  APPLICATION PACKAGE AUTHORITY\\ALL APPLICATION PACKAGES:(OI)(CI)(IO)(GR,GE)
  APPLICATION PACKAGE AUTHORITY\\ALL RESTRICTED APPLICATION PACKAGES:(RX)
  APPLICATION PACKAGE AUTHORITY\\ALL RESTRICTED APPLICATION
  PACKAGES:(OI)(CI)(IO)(GR,GE)
  Successfully processed 1 files; Failed processing 0 files"
  desc "fix", "Maintain the default file ACLs and configure the Security Option
  Network access: Let everyone permissions apply to anonymous users to
  Disabled (WN16-SO-000290).

  Default permissions:
  Type - Allow for all
  Inherited from - None for all

  Principal - Access - Applies to

  TrustedInstaller - Full control - This folder and subfolders
  SYSTEM - Modify - This folder only
  SYSTEM - Full control - Subfolders and files only
  Administrators - Modify - This folder only
  Administrators - Full control - Subfolders and files only
  Users - Read & execute - This folder, subfolders, and files
  CREATOR OWNER - Full control - Subfolders and files only
  ALL APPLICATION PACKAGES - Read & execute - This folder, subfolders, and files
  ALL RESTRICTED APPLICATION PACKAGES - Read & execute - This folder, subfolders,
  and files"

  paths = [
    "C:\\Windows"
  ]

  paths.each do |path|
    acl_rules = json(command: "(Get-ACL -Path '#{path}').Access | ConvertTo-CSV | ConvertFrom-CSV | ConvertTo-JSON").params

    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "268435456" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "CREATOR OWNER" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "ContainerInherit, ObjectInherit" }
          its(['PropagationFlags']) { should cmp "InheritOnly" }
        end
      end
    end
    
    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "268435456" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "NT AUTHORITY\\SYSTEM" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "ContainerInherit, ObjectInherit" }
          its(['PropagationFlags']) { should cmp "InheritOnly" }
        end
      end
    end

    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "Modify, Synchronize" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "NT AUTHORITY\\SYSTEM" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "None" }
          its(['PropagationFlags']) { should cmp "None" }
        end
      end
    end

    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "268435456" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "BUILTIN\\Administrators" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "ContainerInherit, ObjectInherit" }
          its(['PropagationFlags']) { should cmp "InheritOnly" }
        end
      end
    end

    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "268435456" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "NT SERVICE\\TrustedInstaller" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "ContainerInherit" }
          its(['PropagationFlags']) { should cmp "InheritOnly" }
        end
      end
    end


    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "-1610612736" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "BUILTIN\\Users" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "ContainerInherit, ObjectInherit" }
          its(['PropagationFlags']) { should cmp "InheritOnly" }
        end
      end
    end


    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "268435456" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "NT SERVICE\\TrustedInstaller" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "ContainerInherit" }
          its(['PropagationFlags']) { should cmp "InheritOnly" }
        end
      end
    end

    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "FullControl" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "NT SERVICE\\TrustedInstaller" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "None" }
          its(['PropagationFlags']) { should cmp "None" }
        end
      end
    end

    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "ReadAndExecute, Synchronize" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "APPLICATION PACKAGE AUTHORITY\\ALL APPLICATION PACKAGES" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "None" }
          its(['PropagationFlags']) { should cmp "None" }
        end
      end
    end

    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "-1610612736" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "APPLICATION PACKAGE AUTHORITY\\ALL APPLICATION PACKAGES" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "ContainerInherit, ObjectInherit" }
          its(['PropagationFlags']) { should cmp "InheritOnly" }
        end
      end
    end

    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "ReadAndExecute, Synchronize" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "APPLICATION PACKAGE AUTHORITY\\ALL RESTRICTED APPLICATION PACKAGES" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "None" }
          its(['PropagationFlags']) { should cmp "None" }
        end
      end
    end

    describe.one do
      acl_rules.each do |acl_rule|
        describe "The '#{path}' folder\'s access rule property:" do
          subject { acl_rule }
          its(['FileSystemRights']) { should cmp "-1610612736" }
          its(['AccessControlType']) { should cmp "Allow" }
          its(['IdentityReference']) { should cmp "APPLICATION PACKAGE AUTHORITY\\ALL RESTRICTED APPLICATION PACKAGES" }
          its(['IsInherited']) { should cmp "False" }
          its(['InheritanceFlags']) { should cmp "ContainerInherit, ObjectInherit" }
          its(['PropagationFlags']) { should cmp "InheritOnly" }
        end
      end
    end
  end
end
