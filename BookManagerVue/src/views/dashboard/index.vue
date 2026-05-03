<!--
 * @Description: 
 * @Author: Rabbiter
 * @Date: 2023-02-21 18:13:21
-->
<template>
  <div class="dashboard-container">
    <div title="Welcome Page" style="padding: 50px; overflow: hidden; color: #409eff;font: lighter 16px 'Lucida Sans Unicode';"
         data-options="iconCls:'icon-heart',plain:true">
        <b style="font-size: 36px; line-height: 30px; height: 30px;">Welcome to use the library management system</b>
        <hr>
        <b>Introduction to the project development environment</b>
        <p>Operating system: Windows</p>
        <p>Development tools: IntelliJ IDEA 2024.3.4.1 (Ultimate Edition)</p>
        <p>Java version: 1.8.0</p>
        <p>Server: Tomcat 8.5</p>
        <p>Database: MySQL 5.7</p>
        <p>Front-end technology: HTML+CSS+JavaScript+Vue+Axios+ElementUI</p>
        <p>Back-end technology: Java+SpringBoot+MyBatis+MySQL</p>
        <p>AI Platform: Coze</p>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'Dashboard',
  computed: {
    ...mapGetters([
      'id',
      'name',
      'roles'
    ])
  }
}
</script>
