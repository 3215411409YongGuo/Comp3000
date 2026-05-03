import request from '@/utils/request'

// Obtain the quantity of book types
export function getCount() {
    return request({
        url: '/bookType/getCount',
        method: 'get'
    })
}

// Query all book types
export function queryBookTypes() {
    return request({
        url: '/bookType/queryBookTypes',
        method: 'get'
    })
}

// Perform page-based query for book types
export function queryBookTypesByPage(params) {
    return request({
        url: '/bookType/queryBookTypesByPage',
        method: 'get',
        params
    })
}

// Add book type
export function addBookType(data) {
    return request({
        url: '/bookType/addBookType',
        method: 'post',
        data
    })
}

// Delete book type
export function deleteBookType(data) {
    return request({
        url: '/bookType/deleteBookType',
        method: 'delete',
        data
    })
}

//  Delete some types of books
export function deleteBookTypes(data) {
    return request({
        url: '/bookType/deleteBookTypes',
        method: 'delete',
        data
    })
}

//  Update book type
export function updateBookType(data) {
    return request({
        url: '/bookType/updateBookType',
        method: 'put',
        data
    })
}
