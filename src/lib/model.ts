import { getClubAvatar } from "./api";

export enum ClubType {
    All = "all",
    Tech = "tech",
    Acg = "acg",
    Union = "union",
    Profit = "profit",
    Sport = "sport",
    Art = "art",
    Game = "game",
    Unknown = "unknown",
}

export const clubTypeName: Record<ClubType, string> = {
    [ClubType.Tech]: "技术",
    [ClubType.Acg]: "晒你系",
    [ClubType.Union]: "官方",
    [ClubType.Profit]: "商业",
    [ClubType.Sport]: "体育",
    [ClubType.Art]: "文化",
    [ClubType.Unknown]: "未知",
    [ClubType.Game]: "游戏",
    [ClubType.All]: "所有",
};

export class ClubInfo {
    public readonly code: string;
    public readonly type: ClubType[];
    public readonly title: string;
    public readonly intro: string;
    public readonly description: string;
    public readonly qq: string;
    public readonly qqlink: string;
    public readonly pic: number;
    public readonly icon: string;
    public readonly color: string;

    constructor(data: {
        code: string;
        type: ClubType[];
        title: string;
        intro: string;
        description: string;
        qq: string;
        pic: number;
        qqlink: string;
        color: string;
    }) {
        this.code = data.code;
        this.type = data.type;
        this.title = data.title;
        this.intro = data.intro;
        this.description = data.description;
        this.qq = data.qq;
        this.pic = data.pic;
        this.qqlink = data.qqlink;
        this.color = data.color;

        // The 'icon' property is derived from the 'code', just like in the Dart constructor.
        this.icon = getClubAvatar(data.code);
    }

    /**
     * Creates a ClubInfo instance from a raw JSON object.
     * This handles the custom parsing logic from the Dart version.
     */
    public static fromJson(json: any): ClubInfo {
        // Replicates the 'toTypeList' function from Dart.
        const types: ClubType[] = String(json.type || '')
            .split('|')
            .map((value: string) => {
                // This check ensures the string value exists in our enum before casting.
                if (Object.values(ClubType).includes(value as ClubType)) {
                    return value as ClubType;
                }
                return ClubType.Unknown;
            })
            .filter(t => t !== ClubType.Unknown); // Optional: filter out any unknown types

        return new ClubInfo({
            code: String(json.code || ''),
            type: types,
            title: String(json.title || ''),
            intro: String(json.intro || ''),
            description: String(json.description || ''),
            qq: String(json.qq || ''), // Replicates qqFromJson
            pic: Number(json.pic || 0),
            qqlink: String(json.qqlink || ''),
            color: String(json.color || 'deepPurple'), // Replicates fromJsonToColor's default
        });
    }

    /**
     * Converts the ClubInfo instance to a JSON object suitable for serialization.
     */
    public toJson(): Record<string, any> {
        return {
            code: this.code,
            // The type array is joined back into a single '|' delimited string.
            type: this.type.join('|'),
            title: this.title,
            intro: this.intro,
            description: this.description,
            qq: this.qq,
            qqlink: this.qqlink,
            pic: this.pic,
            color: this.color,
            // 'icon' is intentionally omitted to match the Dart '@JsonKey(includeToJson: false)'
        };
    }
}