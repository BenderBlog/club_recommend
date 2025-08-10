// Import the data models and the Result type library
import { ClubInfo, ClubType } from "./model";
import { ok, err, Result } from "neverthrow";

// Define the base URL for all API calls
const baseUrl = "https://legacy.superbart.top/traintime_pda_backend";

/**
 * Fetches the complete list of clubs and filters them by type.
 * @param type The type of club to filter by. Use ClubType.All to get all clubs.
 * @returns A Result containing a list of ClubInfo objects or an Error.
 */
export async function getClubList(type: ClubType): Promise<Result<ClubInfo[], Error>> {
    try {
        const response = await fetch(`${baseUrl}/club.json`);
        if (!response.ok) {
            throw new Error(`Network response was not ok: ${response.statusText}`);
        }

        const data: any[] = await response.json();

        // Map raw data to ClubInfo instances
        let clubs = data.map(json => ClubInfo.fromJson(json));

        // Filter by type, unless the type is 'all'
        if (type !== ClubType.All) {
            clubs = clubs.filter(club => club.type.includes(type));
        }

        return ok(clubs);
    } catch (e) {
        // Ensure we always return an Error object
        return err(e instanceof Error ? e : new Error(String(e)));
    }
}

/**
 * Fetches the information for a single club by its unique code.
 * @param code The unique code of the club (e.g., "flutter_club").
 * @returns A Result containing a single ClubInfo object or an Error if not found.
 */
export async function getClubInfo(code: string): Promise<Result<ClubInfo, Error>> {
    try {
        const response = await fetch(`${baseUrl}/club.json`);
        if (!response.ok) {
            throw new Error(`Network response was not ok: ${response.statusText}`);
        }

        const data: any[] = await response.json();

        // Find the specific club by its code
        const clubJson = data.find(item => item.code === code);

        if (clubJson) {
            return ok(ClubInfo.fromJson(clubJson));
        } else {
            // Return a specific error if the club isn't found
            return err(new Error(`Club with code "${code}" not found.`));
        }
    } catch (e) {
        return err(e instanceof Error ? e : new Error(String(e)));
    }
}

/**
 * Fetches the introductory article (HTML content) for a club.
 * It also corrects relative image paths to be absolute.
 * @param code The unique code of the club.
 * @returns A Promise that resolves to the HTML content as a string.
 */
export async function getClubArticle(code: string): Promise<Result<string, Error>> {
    const articleUrl = `${baseUrl}/club_introduction/${code}/index.html`;
    const response = await fetch(articleUrl);

    if (!response.ok) {
        return err(Error(`Could not fetch article for ${code}: ${response.statusText}`));
    }

    const htmlBody = await response.text();

    // The base URL for images within this specific article
    const imageUrlBase = `${baseUrl}/club_introduction/${code}/`;

    // Replicates the Dart logic to fix relative image paths
    return ok(htmlBody.replaceAll('<img src="', `<img src="${imageUrlBase}`));
}

/**
 * Constructs the URL for a club's main avatar/poster image.
 * @param code The unique code of the club.
 * @returns The full URL to the image.
 */
export function getClubAvatar(code: string): string {
    return `${baseUrl}/poster/${code}.jpg`;
}

/**
 * Constructs the URL for a club's indexed poster image.
 * @param code The unique code of the club.
 * @param index The index of the image.
 * @returns The full URL to the indexed image.
 */
export function getClubImage(code: string, index: number): string {
    return `${baseUrl}/poster/${code}-${index}.jpg`;
}