#if UNITY_2019_1_OR_NEWER
using UnityEditor;
using UnityEngine.UIElements;
using UnityAtoms.Editor;
using NarrativeEvents.Data;

namespace UnityAtoms.BaseAtoms.Editor
{
    /// <summary>
    /// Event property drawer of type `NarrativeEvents.Data.Event`. Inherits from `AtomEventEditor&lt;NarrativeEvents.Data.Event, EventEvent&gt;`. Only availble in `UNITY_2019_1_OR_NEWER`.
    /// </summary>
    [CustomEditor(typeof(EventEvent))]
    public sealed class EventEventEditor : AtomEventEditor<NarrativeEvents.Data.Event, EventEvent> { }
}
#endif
