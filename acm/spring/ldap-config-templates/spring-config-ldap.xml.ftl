<?xml version="1.0" encoding="UTF-8"?>
<beans:beans xmlns="http://www.springframework.org/schema/security"
        xmlns:beans="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:task="http://www.springframework.org/schema/task"
        xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.1.xsd
                            http://www.springframework.org/schema/security http://www.springframework.org/schema/security/spring-security-3.2.xsd
                            http://www.springframework.org/schema/task http://www.springframework.org/schema/task/spring-task-3.2.xsd">

    <beans:bean class="com.armedia.acm.crypto.properties.AcmEncryptablePropertySourcesPlaceholderConfigurer">
        <beans:property name="encryptablePropertyUtils" ref="acmEncryptablePropertyUtils"/>
        <beans:property name="location" value="file:${r'${user.home}'}/.arkcase/acm/spring/spring-config-${id}-ldap.properties"/>
    </beans:bean>
                            
    <!-- change the ref to match the bean name of your ldap sync job; and change the 
         cron to the desired cron expression (see JavaDoc for org.springframework.scheduling.support.CronSequenceGenerator).  
         No other changes are needed. -->
    <task:scheduled-tasks scheduler="ldapSyncTaskScheduler">
        <task:scheduled ref="${id}_ldapSyncJob" method="ldapSync" cron="0 5 * * * *"/>
        <task:scheduled ref="${id}_ldapPartialSyncJob" method="ldapPartialSync" cron="0 0/30 * * * *"/>
    </task:scheduled-tasks>

    <task:annotation-driven scheduler="ldapSyncTaskScheduler"/>

    <!-- ensure this bean id is unique across all the LDAP sync beans. -->
    <beans:bean id="${id}_ldapSyncJob" class="com.armedia.acm.services.users.service.ldap.LdapSyncService">
        <!-- ldapSyncConfig: ref must match an AcmLdapSyncConfig bean, which should be defined below. -->
        <beans:property name="ldapSyncConfig" ref="${id}_sync"/>

        <!-- do not change ldapDao or ldapSyncDatabaseHelper properties. -->
        <beans:property name="ldapDao" ref="customPagedLdapDao"/>
        <beans:property name="springLdapUserDao" ref="springLdapUserDao"/>
        <beans:property name="auditPropertyEntityAdapter" ref="auditPropertyEntityAdapter"/>
        <beans:property name="syncEnabled" value='${r"${ldapConfig.syncEnabled}"}'/>
        <beans:property name="propertyFileManager" ref="propertyFileManager"/>
        <beans:property name="ldapLastSyncPropertyFileLocation" value="${r'${user.home}'}/.arkcase/acm/ldapLastSync.properties"/>
        <beans:property name="ldapSyncProcessor" ref="ldapSyncProcessor"/>
    </beans:bean>
	
	<!-- ensure this bean id is unique across all the partial LDAP sync beans. -->
    <beans:bean id="${id}_ldapPartialSyncJob" class="com.armedia.acm.services.users.service.ldap.LdapSyncService" init-method="ldapPartialSync">
        <!-- ldapSyncConfig: ref must match an AcmLdapSyncConfig bean, which should be defined below. -->
        <beans:property name="ldapSyncConfig" ref="${id}_sync"/>
        <!-- do not change ldapDao or ldapSyncDatabaseHelper properties. -->
        <beans:property name="ldapDao" ref="customPagedLdapDao"/>
        <beans:property name="springLdapUserDao" ref="springLdapUserDao"/>
        <beans:property name="auditPropertyEntityAdapter" ref="auditPropertyEntityAdapter"/>
        <beans:property name="syncEnabled" value='${r"${ldapConfig.syncEnabled}"}'/>
        <beans:property name="propertyFileManager" ref="propertyFileManager"/>
        <beans:property name="ldapLastSyncPropertyFileLocation" value="${r'${user.home}'}/.arkcase/acm/ldapLastSync.properties"/>
        <beans:property name="ldapSyncProcessor" ref="ldapSyncProcessor"/>
    </beans:bean>

    <beans:bean id="${id}_ldapUrl" class="java.lang.String">
        <beans:constructor-arg value='${r"${ldapConfig.ldapUrl}"}'/>
    </beans:bean>

    <beans:bean id="${id}_ldapUrls" factory-bean="${id}_ldapUrl" factory-method="split">
        <beans:constructor-arg value=','/>
    </beans:bean>

    <beans:bean id="${id}_ldap_config" class="com.armedia.acm.services.users.model.ldap.AcmLdapConfig">
        <!-- ldapUrl: URL of the ldap instance (e.g. ldap://arkcase-ce.local:389) -->
        <beans:property name="ldapUrl" ref='${id}_ldapUrls'/>
         <!-- only specify authUserDn if your LDAP server requires user authentication (do not specify if you are using anonymous authentication -->
        <beans:property name="authUserDn" value='${r"${ldapConfig.authUserDn}"}'/>
        <!-- only specify authUserPassword if you also specify authUserDn -->
        <beans:property name="authUserPassword" value='${r"${ldapConfig.authUserPassword}"}'/>
        <!-- base is the domain component (e.g. dc=arkcase-ce,dc=local). -->
        <beans:property name="baseDC" value='${r"${ldapConfig.base}"}'/>
        <!-- userIdAttributeName: use "samAccountName" if your LDAP server is Active Directory.  Most other LDAP servers use "uid". -->
        <beans:property name="userIdAttributeName" value='${r"${ldapConfig.userIdAttributeName}"}'/>
         <!-- mailAttributeName: use "mail"  Most  LDAP servers use "mail". -->
        <beans:property name="mailAttributeName" value="mail"/>
         <!-- ignorePartialResultException: true if your LDAP server is Active Directory, false for other LDAP servers -->
        <beans:property name="ignorePartialResultException" value="true"/>
        <!-- referral: "follow" if you want to follow LDAP referrals, "ignore" otherwise (search "ldap referral" for more info). -->
        <beans:property name="referral" value="follow"/>
        <beans:property name="directoryType" value='${r"${ldapConfig.directoryType}"}'/>
        <beans:property name="directoryName" value='${r"${ldapConfig.id}"}'/>
    </beans:bean>

    <beans:bean id="${id}_sync" class="com.armedia.acm.services.users.model.ldap.AcmLdapSyncConfig" parent="${id}_ldap_config">
        <!-- groupSearchBase is the full tree under which groups are found (e.g. ou=groups,dc=arkcase-ce,dc=local).  -->
        <beans:property name="groupSearchBase" value='${r"${ldapConfig.groupSearchBase}"}'/>
        <!-- groupSearchFilter is an LDAP filter to restrict which entries under the groupSearchBase are processsed -->
        <beans:property name="groupSearchFilter" value='${r"${ldapConfig.groupSearchFilter}"}'/>
        <!-- filter to retrieve all groups with a name greater than some group name - used to page group search results -->
        <beans:property name="groupSearchPageFilter" value='${r"${ldapConfig.groupSearchPageFilter}"}'/>
        <beans:property name="allUsersFilter" value='${r"${ldapConfig.allUsersFilter}"}'/>
        <beans:property name="allChangedUsersFilter" value='${r"${ldapConfig.allChangedUsersFilter}"}'/>
        <beans:property name="allUsersPageFilter" value='${r"${ldapConfig.allUsersPageFilter}"}'/>
        <beans:property name="allChangedUsersPageFilter" value='${r"${ldapConfig.allChangedUsersPageFilter}"}'/>
        <beans:property name="userDomain" value='${r"${ldapConfig.userDomain}"}'/>
        <beans:property name="userPrefix" value='${r"${ldapConfig.userPrefix}"}'/>
        <beans:property name="groupPrefix" value='${r"${ldapConfig.groupPrefix}"}'/>
        <beans:property name="userControlGroup"  value='${r"${ldapConfig.userControlGroup}"}'/>
        <beans:property name="groupControlGroup" value='${r"${ldapConfig.groupControlGroup}"}'/>
        <beans:property name="userSearchBase" value='${r"${ldapConfig.userSearchBase}"}'/>
        <beans:property name="userSearchFilter" value='${r"${ldapConfig.userSearchFilter}"}'/>
        <beans:property name="groupSearchFilterForUser" value='${r"${ldapConfig.groupSearchFilterForUser}"}'/>
        <beans:property name="syncPageSize" value='${r"${ldapConfig.syncPageSize}"}'/>
        <beans:property name="allUsersSortingAttribute" value='${r"${ldapConfig.allUsersSortingAttribute}"}'/>
        <beans:property name="groupsSortingAttribute" value='${r"${ldapConfig.groupsSortingAttribute}"}'/>
        <beans:property name="userSyncAttributes" value='${r"${ldapConfig.userAttributes}"}'/>
        <beans:property name="changedGroupSearchFilter" value='${r"${ldapConfig.changedGroupSearchFilter}"}'/>
        <beans:property name="changedGroupSearchPageFilter" value='${r"${ldapConfig.changedGroupSearchPageFilter}"}'/>
    </beans:bean>

     <beans:bean id="${id}_authenticate" class="com.armedia.acm.services.users.model.ldap.AcmLdapAuthenticateConfig" parent="${id}_ldap_config">
        <!-- userSearchBase is the tree under which users are found (e.g. cn=users).  -->
        <beans:property name="searchBase" value='${r"${ldapConfig.userSearchBase}"}'/>
        <beans:property name="enableEditingLdapUsers" value='${r"${ldapConfig.enableEditingLdapUsers}"}'/>
    </beans:bean>

    <!-- NOTE, do NOT activate both Kerberos and LDAP profiles at the same time.  When the kerberos profile 
         is enabled, the LDAP authentication is still used as a backup, in case Kerberos auth fails.  That 
         is why these beans are active both for Kerberos and LDAP. -->
    <beans:beans profile="ldap,kerberos,externalAuth,externalSaml">

        <beans:bean id="${id}_userSearch" class="org.springframework.security.ldap.search.FilterBasedLdapUserSearch">
            <beans:constructor-arg index="0" value='${r"${ldapConfig.userSearchBase}"}' />
            <beans:constructor-arg index="1" value='${r"${ldapConfig.userIdAttributeName}={0}"}' />
            <beans:constructor-arg index="2" ref="${id}_contextSource" />
        </beans:bean>
        
        <beans:bean id="${id}_authenticationProvider"
                class="com.armedia.acm.auth.AcmLdapAuthenticationProvider">
            <beans:constructor-arg>
                <beans:bean
                        class="org.springframework.security.ldap.authentication.BindAuthenticator">
                    <beans:constructor-arg ref="${id}_contextSource" />
                    <beans:property name="userSearch" ref="${id}_userSearch"/>
                </beans:bean>
            </beans:constructor-arg>
            <beans:constructor-arg>
                <beans:bean
                        class="org.springframework.security.ldap.userdetails.DefaultLdapAuthoritiesPopulator">
                    <beans:constructor-arg ref="${id}_contextSource" />
                    <beans:constructor-arg value='${r"${ldapConfig.groupSearchBase}"}'/>
                    <beans:property name="groupSearchFilter" value="member={0}"/>
                    <beans:property name="rolePrefix" value=""/>
                    <beans:property name="searchSubtree" value="true"/>
                    <beans:property name="convertToUpperCase" value="true"/>
                    <beans:property name="ignorePartialResultException" value="true"/>
                </beans:bean>
            </beans:constructor-arg>
            <beans:property name="userDao" ref="userJpaDao"/>
            <beans:property name="ldapSyncService" ref="${id}_ldapSyncJob"/>
        </beans:bean>

        <beans:bean id="${id}_contextSource"
                    class="org.springframework.ldap.core.support.LdapContextSource">
            <beans:property name="urls" ref='${id}_ldapUrls' />
            <beans:property name="base" value='${r"${ldapConfig.base}"}' />
            <beans:property name="userDn" value='${r"${ldapConfig.authUserDn}"}' />
            <beans:property name="password" value='${r"${ldapConfig.authUserPassword}"}' />
            <beans:property name="pooled" value="true" />
            <!-- AD Specific Setting for avoiding the partial exception error -->
            <beans:property name="referral" value="follow" />
        </beans:bean>

        <beans:bean id="${id}_contextSourceProxy" 
            class="org.springframework.ldap.transaction.compensating.manager.TransactionAwareContextSourceProxy">
             <beans:constructor-arg ref="${id}_contextSource" />
        </beans:bean>

        <beans:bean id="ldapTemplate" class="org.springframework.ldap.core.LdapTemplate">
            <beans:constructor-arg ref="${id}_contextSourceProxy" />
        </beans:bean>

        <beans:bean id="transactionManager" 
            class="org.springframework.ldap.transaction.compensating.manager.ContextSourceTransactionManager">
            <beans:property name="contextSource" ref="${id}_contextSourceProxy" />
        </beans:bean>

       
        <beans:bean id="${id}_ldapSync" 
            class="org.springframework.transaction.interceptor.TransactionProxyFactoryBean">
            <beans:property name="transactionManager" ref="transactionManager" />
            <beans:property name="target" ref="${id}_ldapSyncJob" />
            <beans:property name="transactionAttributes">
                <beans:props>
                    <beans:prop key="*">PROPAGATION_REQUIRES_NEW</beans:prop>
                </beans:props>
            </beans:property>
        </beans:bean>

        <!--
        Authenticates a user id and password against LDAP directory.  To support multiple LDAP configurations, create multiple Spring 
        beans, each with its own LdapAuthenticateService.
        -->
        <beans:bean id="${id}_ldapAuthenticateService" class="com.armedia.acm.services.users.service.ldap.LdapAuthenticateService">
            <!-- ldapAuthenticateConfig: ref must match an AcmLdapAuthenticateConfig bean -->
            <beans:property name="ldapAuthenticateConfig" ref="${id}_authenticate"/>
            <!-- ldapSyncConfig: ref must match an AcmLdapSyncConfig bean -->
            <beans:property name="ldapSyncConfig" ref="${id}_sync"/>
            <!-- do not change ldapDao properties. -->
            <beans:property name="ldapDao" ref="customPagedLdapDao"/>
            <beans:property name="userDao" ref="userJpaDao"/>
            <beans:property name="ldapUserDao" ref="springLdapUserDao"/>
        </beans:bean>

    </beans:beans>

    <beans:beans profile="externalAuth,externalSaml">
        <beans:bean id="${id}_userDetailsService"
                    class="com.armedia.acm.auth.AcmLdapUserDetailsService">
            <beans:constructor-arg index="0" ref="${id}_userSearch"/>
            <beans:constructor-arg index="1">
                <beans:bean id="${id}_authoritiesPopulator"
                            class="org.springframework.security.ldap.userdetails.DefaultLdapAuthoritiesPopulator">
                    <beans:constructor-arg index="0" ref="${id}_contextSource"/>
                    <beans:constructor-arg index="1" value='${r"${ldapConfig.groupSearchBase}"}'/>
                </beans:bean>
            </beans:constructor-arg>
            <beans:property name="acmLdapSyncConfig" ref="${id}_sync"/>
        </beans:bean>
        <beans:bean id="${id}_externalAuthProvider"
                    class="org.springframework.security.web.authentication.preauth.PreAuthenticatedAuthenticationProvider">
            <beans:property name="preAuthenticatedUserDetailsService">
                <beans:bean id="${id}_userDetailsServiceWrapper"
                            class="org.springframework.security.core.userdetails.UserDetailsByNameServiceWrapper">
                    <beans:property name="userDetailsService" ref="${id}_userDetailsService"/>
                </beans:bean>
            </beans:property>
        </beans:bean>
    </beans:beans>
</beans:beans>
