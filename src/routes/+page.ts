import { getClubList } from '$lib/api';
import { ClubType } from '$lib/model';
import type { PageLoad } from './$types';

export const load: PageLoad = ({ }) => {
    const clubListPromise = getClubList(ClubType.All);
    return {
        clubListPromise
    };
};
