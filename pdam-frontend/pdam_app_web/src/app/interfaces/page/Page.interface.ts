import { GetUserDto } from "../user/GetUserDto.interface"

export interface PageUsers {
    content: GetUserDto[]
    currentPage: number
    last: boolean
    first: boolean
    totalPages: number
    totalElements: number
}
