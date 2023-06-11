export interface GetUserDto {
    id: string
    userName: string
    fullName: string
    imgPath: string
    followers: number
    countOfPosts: number
    verified: boolean
    followedByUser: boolean
    createdAt: string
}
