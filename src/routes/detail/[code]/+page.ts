import { getClubInfo } from '$lib/api';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ params }) => {
    const clubInfoResult = params.code.length === 0 ? null : await getClubInfo(params.code);

    return {
        clubInfoResult,
    };
};
