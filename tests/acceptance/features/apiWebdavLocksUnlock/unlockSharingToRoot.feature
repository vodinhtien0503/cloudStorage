@api @issue-ocis-reva-172 @files_sharing-app-required @notToImplementOnOCIS
Feature: UNLOCK locked items (sharing)

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has created folder "PARENT"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "PARENT/parent.txt"


  Scenario Outline: as share receiver unlocking a shared file locked by the file owner is not possible. To unlock use the owners locktoken
    Given using <dav-path> DAV path
    And user "Alice" has locked file "PARENT/parent.txt" setting the following properties
      | lockscope | <lock-scope> |
    And user "Alice" has shared file "PARENT/parent.txt" with user "Brian"
    When user "Brian" unlocks file "parent.txt" with the last created lock of file "PARENT/parent.txt" of user "Alice" using the WebDAV API
    Then the HTTP status code should be "403"
    And 1 locks should be reported for file "PARENT/parent.txt" of user "Alice" by the WebDAV API
    And 1 locks should be reported for file "parent.txt" of user "Brian" by the WebDAV API
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |


  Scenario Outline: as share receiver unlocking a file in a share locked by the file owner is not possible. To unlock use the owners locktoken
    Given using <dav-path> DAV path
    And user "Brian" has created folder "PARENT"
    And user "Brian" has uploaded file "filesForUpload/textfile.txt" to "PARENT/parent.txt"
    And user "Alice" has locked file "PARENT/parent.txt" setting the following properties
      | lockscope | <lock-scope> |
    And user "Alice" has shared folder "PARENT" with user "Brian"
    When user "Brian" unlocks file "PARENT (2)/parent.txt" with the last created lock of file "PARENT/parent.txt" of user "Alice" using the WebDAV API
    Then the HTTP status code should be "403"
    And 1 locks should be reported for file "PARENT/parent.txt" of user "Alice" by the WebDAV API
    And 1 locks should be reported for file "PARENT (2)/parent.txt" of user "Brian" by the WebDAV API
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |


  Scenario Outline: as share receiver unlocking a shared folder locked by the file owner is not possible. To unlock use the owners locktoken
    Given using <dav-path> DAV path
    And user "Alice" has created folder "PARENT/CHILD"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "PARENT/CHILD/child.txt"
    And user "Alice" has locked folder "PARENT" setting the following properties
      | lockscope | <lock-scope> |
    And user "Alice" has shared folder "PARENT" with user "Brian"
    When user "Brian" unlocks folder "PARENT" with the last created lock of folder "PARENT" of user "Alice" using the WebDAV API
    Then the HTTP status code should be "403"
    And 3 locks should be reported for folder "PARENT" of user "Alice" by the WebDAV API
    And 2 locks should be reported for folder "PARENT/CHILD" of user "Alice" by the WebDAV API
    And 1 locks should be reported for file "PARENT/parent.txt" of user "Alice" by the WebDAV API
    And 3 locks should be reported for folder "PARENT" of user "Brian" by the WebDAV API
    And 2 locks should be reported for folder "PARENT/CHILD" of user "Brian" by the WebDAV API
    And 1 locks should be reported for file "PARENT/parent.txt" of user "Brian" by the WebDAV API
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |


  Scenario Outline: as share receiver unlock a shared file
    Given using <dav-path> DAV path
    And user "Alice" has shared file "PARENT/parent.txt" with user "Brian"
    And user "Brian" has locked file "parent.txt" setting the following properties
      | lockscope | <lock-scope> |
    When user "Brian" unlocks the last created lock of file "parent.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And 0 locks should be reported for file "PARENT/parent.txt" of user "Alice" by the WebDAV API
    And 0 locks should be reported for file "parent.txt" of user "Brian" by the WebDAV API
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |


  Scenario Outline: as owner unlocking a shared file locked by the receiver is not possible. To unlock use the receivers locktoken
    Given using <dav-path> DAV path
    And user "Alice" has shared file "PARENT/parent.txt" with user "Brian"
    And user "Brian" has locked file "parent.txt" setting the following properties
      | lockscope | <lock-scope> |
    When user "Alice" unlocks file "PARENT/parent.txt" with the last created lock of file "parent.txt" of user "Brian" using the WebDAV API
    Then the HTTP status code should be "403"
    And 1 locks should be reported for file "PARENT/parent.txt" of user "Alice" by the WebDAV API
    And 1 locks should be reported for file "parent.txt" of user "Brian" by the WebDAV API
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |


  Scenario Outline: as owner unlocking a file in a share that was locked by the share receiver is not possible. To unlock use the receivers locktoken
    Given using <dav-path> DAV path
    And user "Alice" has shared folder "PARENT" with user "Brian"
    And user "Brian" has locked file "PARENT/parent.txt" setting the following properties
      | lockscope | <lock-scope> |
    When user "Alice" unlocks file "PARENT/parent.txt" with the last created lock of file "PARENT/parent.txt" of user "Brian" using the WebDAV API
    Then the HTTP status code should be "403"
    And 1 locks should be reported for file "PARENT/parent.txt" of user "Alice" by the WebDAV API
    And 1 locks should be reported for file "PARENT/parent.txt" of user "Brian" by the WebDAV API
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |


  Scenario Outline: as owner unlocking a shared folder locked by the share receiver is not possible. To unlock use the receivers locktoken
    Given using <dav-path> DAV path
    And user "Alice" has created folder "PARENT/CHILD"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "PARENT/CHILD/child.txt"
    And user "Alice" has shared folder "PARENT" with user "Brian"
    And user "Brian" has locked folder "PARENT" setting the following properties
      | lockscope | <lock-scope> |
    When user "Alice" unlocks folder "PARENT" with the last created lock of folder "PARENT" of user "Brian" using the WebDAV API
    Then the HTTP status code should be "403"
    And 3 locks should be reported for folder "PARENT" of user "Alice" by the WebDAV API
    And 2 locks should be reported for folder "PARENT/CHILD" of user "Alice" by the WebDAV API
    And 1 locks should be reported for file "PARENT/parent.txt" of user "Alice" by the WebDAV API
    And 3 locks should be reported for folder "PARENT" of user "Brian" by the WebDAV API
    And 2 locks should be reported for folder "PARENT/CHILD" of user "Brian" by the WebDAV API
    And 1 locks should be reported for file "PARENT/parent.txt" of user "Brian" by the WebDAV API
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |
