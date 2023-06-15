export interface GetAttendedEventsDto {
    content: GetEventDto[]
    currentPage: number
    last: boolean
    first: boolean
    totalPages: number
    totalElements: number
}

export interface GetEventDto {
    id: number
    name: string
    location: string
    city: string
    popularity: number
    imgPath: string
}
