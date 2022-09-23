using UnityEngine;
using NarrativeEvents.Data;

namespace UnityAtoms.BaseAtoms
{
    /// <summary>
    /// Value List of type `NarrativeEvents.Data.Event`. Inherits from `AtomValueList&lt;NarrativeEvents.Data.Event, EventEvent&gt;`.
    /// </summary>
    [EditorIcon("atom-icon-piglet")]
    [CreateAssetMenu(menuName = "Unity Atoms/Value Lists/Event", fileName = "EventValueList")]
    public sealed class EventValueList : AtomValueList<NarrativeEvents.Data.Event, EventEvent> { }
}
