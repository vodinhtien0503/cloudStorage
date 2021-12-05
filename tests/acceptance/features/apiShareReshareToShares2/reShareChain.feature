@api @files_sharing-app-required @issue-ocis-2141
Feature: resharing can be done on a reshared resource

  Background:
    Given the administrator has set the default folder for received shares to "Shares"
    And auto-accept shares has been disabled
    And these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
      | Carol    |
      | David    |

  @notToImplementOnOCIS
  Scenario Outline: Reshared files can be still accessed if a user in the middle removes it.
    Given user "Alice" has uploaded file with content "ownCloud test text file 0" to "/textfile0.txt"
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Brian" has moved file "/Shares/textfile0.txt" to "/textfile0_shared.txt"
    And user "Brian" has shared file "/textfile0_shared.txt" with user "Carol"
    And user "Carol" has accepted share "<pending_share_path>" offered by user "Brian"
    And user "Carol" has shared file "/Shares/textfile0_shared.txt" with user "David"
    And user "David" has accepted share "<pending_share_path>" offered by user "Carol"
    When user "Brian" deletes file "/textfile0_shared.txt" using the WebDAV API
    Then the content of file "/Shares/textfile0_shared.txt" for user "Carol" should be "ownCloud test text file 0"
    And the content of file "/Shares/textfile0_shared.txt" for user "David" should be "ownCloud test text file 0"
    @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
    Examples:
      | pending_share_path    |
      | /textfile0_shared.txt |
      | /textfile0_shared.txt |

    @skipOnAllVersionsGreaterThanOcV10.8.0 @skipOnOcis @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
    Examples:
      | pending_share_path |
      | /textfile0.txt     |
      | /textfile0.txt     |


  @skipOnOcV10
  Scenario: Reshared files can be still accessed if a user in the middle removes it.
    Given user "Alice" has uploaded file with content "ownCloud test text file 0" to "/textfile0.txt"
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Brian" has shared file "/Shares/textfile0.txt" with user "Carol"
    And user "Carol" has accepted share "/textfile0.txt" offered by user "Brian"
    And user "Carol" has shared file "/Shares/textfile0.txt" with user "David"
    And user "David" has accepted share "/textfile0.txt" offered by user "Carol"
    When user "Brian" deletes file "/Shares/textfile0.txt" using the WebDAV API
    Then the content of file "/Shares/textfile0.txt" for user "Carol" should be "ownCloud test text file 0"
    And the content of file "/Shares/textfile0.txt" for user "David" should be "ownCloud test text file 0"
