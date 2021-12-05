@api
Feature: LOCK file/folder

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has uploaded file with content "some data" to "/textfile0.txt"
    And user "Alice" has uploaded file with content "some data" to "/textfile1.txt"
    And user "Alice" has created folder "/PARENT"
    And user "Alice" has created folder "/FOLDER"
    And user "Alice" has uploaded file with content "some data" to "/PARENT/parent.txt"

  @smokeTest
  @skipOnBruteForceProtection @issue-brute_force_protection-112
  Scenario: send LOCK requests to webDav endpoints as normal user with wrong password
    When user "Alice" requests these endpoints with "LOCK" including body "doesnotmatter" using password "invalid" about user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @smokeTest
  @skipOnBruteForceProtection @issue-brute_force_protection-112
  Scenario: send LOCK requests to webDav endpoints as normal user with no password
    When user "Alice" requests these endpoints with "LOCK" including body "doesnotmatter" using password "" about user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @issue-ocis-reva-9 @skipOnOcV10.3 @skipOnOcV10.4 @skipOnOcV10.5
  Scenario: send LOCK requests to another user's webDav endpoints as normal user
    When user "Brian" requests these endpoints with "LOCK" to get property "d:shared" about user "Alice"
      | endpoint                                       |
      | /remote.php/dav/files/%username%/textfile0.txt |
      | /remote.php/dav/files/%username%/PARENT        |
    Then the HTTP status code of responses on all endpoints should be "403"
    When user "Brian" requests these endpoints with "LOCK" to get property "d:shared" about user "Alice"
      | endpoint                                           |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "409"

  Scenario: send LOCK requests to webDav endpoints using invalid username but correct password
    When user "usero" requests these endpoints with "LOCK" including body "doesnotmatter" using the password of user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  Scenario: send LOCK requests to webDav endpoints using valid password and username of different user
    When user "Brian" requests these endpoints with "LOCK" including body "doesnotmatter" using the password of user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @smokeTest
  @skipOnBruteForceProtection @issue-brute_force_protection-112
  Scenario: send LOCK requests to webDav endpoints without any authentication
    When a user requests these endpoints with "LOCK" with body "doesnotmatter" and no authentication about user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @notToImplementOnOCIS @issue-ocis-reva-37
  Scenario: send LOCK requests to webDav endpoints using token authentication should not work
    Given token auth has been enforced
    And a new browser session for "Alice" has been started
    And the user has generated a new app password named "my-client"
    When the user requests these endpoints with "LOCK" using the generated app password about user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile0.txt     |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/PARENT            |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
    Then the HTTP status code of responses on all endpoints should be "401"

  @notToImplementOnOCIS @issue-ocis-reva-37
  Scenario: send LOCK requests to webDav endpoints using app password token as password
    Given token auth has been enforced
    And a new browser session for "Alice" has been started
    And the user has generated a new app password named "my-client"
    When the user "Alice" requests these endpoints with "LOCK" to get property "d:shared" using basic auth and generated app password about user "Alice"
      | endpoint                                           |
      | /remote.php/webdav/textfile0.txt                   |
      | /remote.php/dav/files/%username%/textfile1.txt     |
      | /remote.php/dav/files/%username%/PARENT/parent.txt |
      | /remote.php/webdav/PARENT                          |
      | /remote.php/dav/files/%username%/FOLDER            |
    Then the HTTP status code of responses on all endpoints should be "200"
