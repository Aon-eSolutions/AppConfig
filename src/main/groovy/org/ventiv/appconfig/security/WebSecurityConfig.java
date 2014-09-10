/**
 * Copyright (c) 2014 Ventiv Technology
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
package org.ventiv.appconfig.security;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.authentication.configurers.GlobalAuthenticationConfigurerAdapter;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.servlet.configuration.EnableWebMvcSecurity;
import org.ventiv.appconfig.AllProperties;

import javax.annotation.Resource;

/**
 * @author John Crygier
 */
@Configuration
@EnableWebMvcSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests().antMatchers("/").permitAll();
        http.authorizeRequests().antMatchers("/**").permitAll();
        http.csrf().disable();
    }

    @Configuration
    @ConditionalOnProperty(prefix = "ldap.server.", value = "url")
    protected static class LdapServerAuthenticationConfiguration extends GlobalAuthenticationConfigurerAdapter {

        @Resource AllProperties props;

        @Override
        public void init(AuthenticationManagerBuilder auth) throws Exception {
            auth.ldapAuthentication()
                    .userSearchBase(props.getLdap().getUser().getSearch().getBase())
                    .userSearchFilter(props.getLdap().getUser().getSearch().getFilter())
                    .groupSearchBase(props.getLdap().getGroup().getSearch().getBase())
                    .groupSearchFilter(props.getLdap().getGroup().getSearch().getFilter())
                    .contextSource()
                        .url(props.getLdap().getServer().getUrl())
                        .managerDn(props.getLdap().getServer().getManager().getDn())
                        .managerPassword(props.getLdap().getServer().getManager().getPassword());
        }
    }

    @Configuration
    @ConditionalOnProperty(prefix = "ldap.server.", value = "ldif")
    protected static class LdapFileAuthenticationConfiguration extends GlobalAuthenticationConfigurerAdapter {

        @Resource AllProperties props;

        @Override
        public void init(AuthenticationManagerBuilder auth) throws Exception {
            auth.ldapAuthentication()
                    .userSearchBase(props.getLdap().getUser().getSearch().getBase())
                    .userSearchFilter(props.getLdap().getUser().getSearch().getFilter())
                    .groupSearchBase(props.getLdap().getGroup().getSearch().getBase())
                    .groupSearchFilter(props.getLdap().getGroup().getSearch().getFilter())
                    .contextSource().ldif(props.getLdap().getServer().getLdif());
        }
    }
}
