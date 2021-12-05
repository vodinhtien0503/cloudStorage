@api @files_sharing-app-required @issue-ocis-reva-172 @issue-ocis-reva-11 @notToImplementOnOCIS
Feature: lock should propagate correctly if a share is reshared

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
      | Carol    |
    And user "Alice" has created folder "PARENT"
    And user "Brian" has created folder "PARENT"
    And user "Carol" has created folder "PARENT"

  Scenario Outline: upload to a share that was locked by owner
    Given using <dav-path> DAV path
    And user "Alice" has shared folder "PARENT" with user "Brian"
    And user "Brian" has shared folder "PARENT (2)" with user "Carol"
    And user "Alice" has locked folder "PARENT" setting the following properties
      | lockscope | <lock-scope> |
    When user "Carol" uploads file "filesForUpload/textfile.txt" to "/PARENT (2)/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    When user "Brian" uploads file "filesForUpload/textfile.txt" to "/PARENT (2)/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    When user "Alice" uploads file "filesForUpload/textfile.txt" to "/PARENT/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    And as "Alice" file "/PARENT/textfile.txt" should not exist
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |

  Scenario Outline: upload overwriting to a share that was locked by owner
    Given using <dav-path> DAV path
    And user "Alice" has uploaded file with content "ownCloud test text file parent" to "PARENT/parent.txt"
    And user "Brian" has uploaded file with content "ownCloud test text file parent" to "PARENT/parent.txt"
    And user "Carol" has uploaded file with content "ownCloud test text file parent" to "PARENT/parent.txt"
    And user "Alice" has shared folder "PARENT" with user "Brian"
    And user "Brian" has shared folder "PARENT (2)" with user "Carol"
    And user "Alice" has locked folder "PARENT" setting the following properties
      | lockscope | <lock-scope> |
    When user "Carol" uploads file "filesForUpload/textfile.txt" to "/PARENT (2)/parent.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    When user "Brian" uploads file "filesForUpload/textfile.txt" to "/PARENT (2)/parent.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    When user "Alice" uploads file "filesForUpload/textfile.txt" to "/PARENT/parent.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    And the content of file "/PARENT/parent.txt" for user "Alice" should be "ownCloud test text file parent"
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |

  @skipOnOcV10.6 @skipOnOcV10.7
  Scenario Outline: public uploads to a reshared share that was locked by original owner
    Given using <dav-path> DAV path
    And user "Alice" has shared folder "PARENT" with user "Brian"
    And user "Brian" has shared folder "PARENT (2)" with user "Carol"
    And user "Carol" has created a public link share of folder "PARENT (2)" with change permission
    And user "Alice" has locked folder "PARENT" setting the following properties
      | lockscope | <lock-scope> |
    When the public uploads file "test.txt" with content "test" using the new public WebDAV API
    Then the HTTP status code should be "423"
    And as "Alice" file "/PARENT/test.txt" should not exist
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |

  Scenario Outline: upload to a share that was locked by owner but renamed before
    Given using <dav-path> DAV path
    And user "Alice" has shared folder "PARENT" with user "Brian"
    And user "Brian" has shared folder "PARENT (2)" with user "Carol"
    When user "Brian" moves folder "/PARENT (2)" to "/PARENT-renamed" using the WebDAV API
    And user "Alice" locks folder "PARENT" using the WebDAV API setting the following properties
      | lockscope | <lock-scope> |
    And user "Carol" uploads file "filesForUpload/textfile.txt" to "/PARENT (2)/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    When user "Brian" uploads file "filesForUpload/textfile.txt" to "/PARENT-renamed/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    When user "Alice" uploads file "filesForUpload/textfile.txt" to "/PARENT/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    And as "Alice" file "/PARENT/textfile.txt" should not exist
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |

  Scenario Outline: upload to a share that was locked by the resharing user
    Given using <dav-path> DAV path
    And user "Alice" has shared folder "PARENT" with user "Brian"
    And user "Brian" has shared folder "PARENT (2)" with user "Carol"
    And user "Brian" has locked folder "PARENT (2)" setting the following properties
      | lockscope | <lock-scope> |
    When user "Carol" uploads file "filesForUpload/textfile.txt" to "/PARENT (2)/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    When user "Brian" uploads file "filesForUpload/textfile.txt" to "/PARENT (2)/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    When user "Alice" uploads file "filesForUpload/textfile.txt" to "/PARENT/textfile.txt" using the WebDAV API
    Then the HTTP status code should be "423"
    And as "Alice" file "/PARENT/textfile.txt" should not exist
    Examples:
      | dav-path | lock-scope |
      | old      | shared     |
      | old      | exclusive  |
      | new      | shared     |
      | new      | exclusive  |
