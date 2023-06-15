export interface NewFestivalDto {
    name: string
    description: string
    location: string
    cityId: number
    capacity: number
    dateTime: string
    duration: number
    price: number
    drinkIncluded: boolean
    numberOfDrinks: number
    adult: boolean
}

export interface NewDiscothequeDto {
    name: string
    cityId: number
    location: string
    capacity: number
}
