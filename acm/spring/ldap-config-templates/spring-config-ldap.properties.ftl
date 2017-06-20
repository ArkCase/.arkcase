# id refers to directory name which must be unique across all LDAP sync beans
ldapConfig.id=${id}
ldapConfig.base=${base}
ldapConfig.authUserDn=${authUserDn}
ldapConfig.authUserPassword=${authUserPassword}

ldapConfig.userSearchBase=${userSearchBase}
ldapConfig.groupSearchBase=${groupSearchBase}

ldapConfig.ldapUrl=${ldapUrl}

ldapConfig.userAttributes=cn,userAccountControl,sn,givenName,dn,distinguishedname,memberOf,sAMAccountName,userPrincipalName,uid,uidNumber,c,co,company,department,title,shadowMax,shadowLastChange,msDS-UserPasswordExpiryTimeComputed

# Set the user' federated domain name in case of Single Sing-On scenraio. Leave it blank when authenticating against LDAP directly
ldapConfig.userDomain=${userDomain}

ldapConfig.syncPageSize=${syncPageSize}

ldapConfig.enableEditingLdapUsers=${enableEditingLdapUsers?c}
ldapConfig.directoryType=${directoryType}

ldapConfig.userSearchFilter=${userSearchFilter}
ldapConfig.allUsersFilter=${allUsersFilter}
ldapConfig.allUsersPageFilter=${allUsersPageFilter}
ldapConfig.allUsersSortingAttribute=${allUsersSortingAttribute}
ldapConfig.groupSearchFilterForUser=${groupSearchFilterForUser}
ldapConfig.userIdAttributeName=${userIdAttributeName}
ldapConfig.groupSearchFilter=${groupSearchFilter}
ldapConfig.groupSearchPageFilter=${groupSearchPageFilter}
ldapConfig.groupsSortingAttribute=${groupsSortingAttribute}

