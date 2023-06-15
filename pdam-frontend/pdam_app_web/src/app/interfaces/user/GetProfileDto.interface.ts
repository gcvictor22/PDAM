export interface GetProfileDto {
    id: string
    userName: string
    fullName: string
    imgPath: string
    email: string
    phoneNumber: string
    follows: number
    followers: number
    publishedPosts: PublishedPosts
    followedByUser: boolean
    verified: boolean
    city: string
    authEvent: any
    authorized: boolean
    createdAt: string
    loggedUser: boolean
}

export interface PublishedPosts {
    content: Post[]
    currentPage: number
    last: boolean
    first: boolean
    totalPages: number
    totalElements: number
}

export interface Post {
    id: number
    affair: string
    content: string
    imgPath: string[]
    userWhoPost: UserWhoPost
    usersWhoLiked: number
    comments: number
    likedByUser: boolean
    postDate: string
}

export interface UserWhoPost {
    userName: string
    imgPath: string
    verified: boolean
    followedByUser: boolean
    loggedUser: boolean
}
