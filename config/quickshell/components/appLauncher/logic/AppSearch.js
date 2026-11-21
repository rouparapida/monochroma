.pragma library

// convert values into searchable text
function asText(value) {
    if (value === undefined || value === null)
        return "";

    if (typeof value === "string")
        return value;

    if (value.join)
        return value.join(" ");

    return String(value);
}

// normalize text for case-insensitive and accent-insensitive search
function normalize(value) {
    let text = asText(value).toLowerCase().trim();

    try {
        text = text.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    } catch (error) {
        // keep the lowercase value when unicode normalization is unavailable
    }

    return text;
}

// calculate match score based on the token position
function fieldScore(field, token, weight) {
    if (!field)
        return 0;

    if (field === token)
        return weight * 4;

    if (field.indexOf(token) === 0)
        return weight * 3;

    if (field.indexOf(" " + token) >= 0)
        return weight * 2.5;

    if (field.indexOf(token) >= 0)
        return weight * 2;

    return 0;
}

// rank an application based on its searchable fields
function scoreEntry(entry, query) {
    const name = normalize(entry.name);

    // prioritize the most relevant application fields
    const fields = [
        { value: name, weight: 100 },
        { value: normalize(entry.genericName), weight: 75 },
        { value: normalize(entry.aliases), weight: 85 },
        { value: normalize(entry.keywords), weight: 65 },
        { value: normalize(entry.id), weight: 45 },
        { value: normalize(entry.comment), weight: 35 },
        { value: normalize(entry.categories), weight: 25 }
    ];

    // split the query into individual tokens
    const tokens = query.split(/\s+/).filter(function(token) {
        return token.length > 0;
    });

    let score = 0;

    // every token must match at least one field
    for (let i = 0; i < tokens.length; i++) {
        let best = 0;

        for (let j = 0; j < fields.length; j++) {
            best = Math.max(
                best,
                fieldScore(fields[j].value, tokens[i], fields[j].weight)
            );
        }

        if (best === 0)
            return -1;

        score += best;
    }

    // apply additional bonuses for direct name matches
    if (name === query)
        score += 1000;
    else if (name.indexOf(query) === 0)
        score += 450;
    else if (name.indexOf(query) >= 0)
        score += 180;

    return score;
}

// search, rank and return matching applications
function search(entries, rawQuery, maxResults) {
    const query = normalize(rawQuery);

    if (!query)
        return [];

    const ranked = [];
    const seen = Object.create(null);
    const source = entries || [];

    // filter invalid and duplicate entries
    for (let i = 0; i < source.length; i++) {
        const entry = source[i];

        if (!entry || entry.noDisplay)
            continue;

        const key = normalize(entry.id || entry.name);

        if (!key || seen[key])
            continue;

        seen[key] = true;

        // calculate relevance for the current entry
        const score = scoreEntry(entry, query);

        if (score >= 0) {
            ranked.push({
                entry: entry,
                score: score
            });
        }
    }

    // sort by score, then alphabetically
    ranked.sort(function(a, b) {
        if (a.score !== b.score)
            return b.score - a.score;

        const aName = normalize(a.entry.name);
        const bName = normalize(b.entry.name);

        return aName < bName ? -1 : (aName > bName ? 1 : 0);
    });

    // limit the number of returned results
    const limit = Math.max(1, maxResults || 80);

    return ranked.slice(0, limit).map(function(item) {
        return {
            entry: item.entry,
            score: item.score
        };
    });
}