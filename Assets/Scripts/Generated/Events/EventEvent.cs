using UnityEngine;
using NarrativeEvents.Data;

namespace UnityAtoms.BaseAtoms
{
    /// <summary>
    /// Event of type `NarrativeEvents.Data.Event`. Inherits from `AtomEvent&lt;NarrativeEvents.Data.Event&gt;`.
    /// </summary>
    [EditorIcon("atom-icon-cherry")]
    [CreateAssetMenu(menuName = "Unity Atoms/Events/Event", fileName = "EventEvent")]
    public sealed class EventEvent : AtomEvent<NarrativeEvents.Data.Event>
    {
    }
}
