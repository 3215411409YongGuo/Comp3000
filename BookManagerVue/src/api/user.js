import request from '@/utils/request'

// Log in
export function login(data) {
  return request({
    url: '/user/login',
    method: 'post',
    data
  })
}

// Obtain user information
export function getInfo(token) {
  return request({
    url: '/user/info',
    method: 'get',
    params: { token }
  })
}

// Log out
export function logout(token) {
  return request({
    url: '/user/logout',
    method: 'post',
    params: { token }
  })
}

// Registration
export function register(params) {
  return request({
    url: '/user/register',
    method: 'post',
    params
  })
}

// Change password
export function alterPassword(params) {
  return request({
    url: '/user/alterPassword',
    method: 'post',
    params
  })
}

// Obtain the number of users
export function getCount() {
  return request({
    url: '/user/getCount',
    method: 'get'
  })
}

// Query all user information
export function queryUsers() {
  return request({
    url: '/user/queryUsers',
    method: 'get'
  })
}

// Perform page-based query for user information
export function queryUsersByPage(params) {
  return request({
    url: '/user/queryUsersByPage',
    method: 'get',
    params
  })
}

// Add user information
export function addUser(data) {
  return request({
    url: '/user/addUser',
    method: 'post',
    data
  })
}

// Delete user information
export function deleteUser(data) {
  return request({
    url: '/user/deleteUser',
    method: 'delete',
    data
  })
}

//  Delete some user information
export function deleteUsers(data) {
  return request({
    url: '/user/deleteUsers',
    method: 'delete',
    data
  })
}

//  Update user information
export function updateUser(data) {
  return request({
    url: '/user/updateUser',
    method: 'put',
    data
  })
}
