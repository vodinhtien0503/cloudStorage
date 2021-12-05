<?php
/*
 * Copyright 2014 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

class Google_Service_GKEHub_MembershipFeatureSpec extends Google_Model
{
  protected $configmanagementType = 'Google_Service_GKEHub_ConfigManagementMembershipSpec';
  protected $configmanagementDataType = '';

  /**
   * @param Google_Service_GKEHub_ConfigManagementMembershipSpec
   */
  public function setConfigmanagement(Google_Service_GKEHub_ConfigManagementMembershipSpec $configmanagement)
  {
    $this->configmanagement = $configmanagement;
  }
  /**
   * @return Google_Service_GKEHub_ConfigManagementMembershipSpec
   */
  public function getConfigmanagement()
  {
    return $this->configmanagement;
  }
}
